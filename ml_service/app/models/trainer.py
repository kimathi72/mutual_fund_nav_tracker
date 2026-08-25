from __future__ import annotations

from pathlib import Path

import joblib
import pandas as pd

from sklearn.model_selection import TimeSeriesSplit
from xgboost import XGBRegressor

from app.config import (
    FEATURE_COLUMNS,
    TARGET_COLUMNS,
    RANDOM_STATE,
)

from app.models.evaluator import Evaluator
from app.utils.persistence import save_metrics


class Trainer:
    """
    Trains three quantile XGBoost models for one horizon.

    Models:

        lower  = 10th percentile
        median = 50th percentile
        upper  = 90th percentile

    Targets are actual future NAV values.
    """

    QUANTILES = {
        "lower": 0.10,
        "median": 0.50,
        "upper": 0.90,
    }

    def __init__(
        self,
        dataframe: pd.DataFrame,
        model_directory: Path,
    ):

        self.df = (
            dataframe
            .copy()
            .sort_values(
                ["isin", "nav_date"]
            )
            .reset_index(drop=True)
        )

        self.model_directory = Path(
            model_directory
        )

        self.model_directory.mkdir(
            parents=True,
            exist_ok=True,
        )

        self.horizon = (
            self.model_directory.name
        )

        if self.horizon not in TARGET_COLUMNS:
            raise ValueError(
                f"Unsupported horizon: {self.horizon}"
            )

        self.target_column = (
            TARGET_COLUMNS[self.horizon]
        )

    # --------------------------------------------------
    # Train
    # --------------------------------------------------

    def train(self):

        X = self.df[
            FEATURE_COLUMNS
        ]

        y = self.df[
            self.target_column
        ]

        if X.empty:
            raise ValueError(
                f"No training rows for {self.horizon}"
            )

        if y.isna().any():
            raise ValueError(
                f"Training target {self.target_column} "
                "contains NULL values."
            )

        print("=" * 80)

        print(
            f"Training horizon: {self.horizon}"
        )

        print(
            f"Target column: {self.target_column}"
        )

        print(
            f"Training rows: {len(self.df)}"
        )

        print("\nTarget statistics")

        print(
            y.describe()
        )

        print("=" * 80)

        splitter = TimeSeriesSplit(
            n_splits=5
        )

        evaluator = Evaluator()

        fold_results = []

        for fold, (
            train_index,
            test_index,
        ) in enumerate(
            splitter.split(X),
            start=1,
        ):

            print(
                f"Training fold {fold}/5..."
            )

            X_train = X.iloc[
                train_index
            ]

            X_test = X.iloc[
                test_index
            ]

            y_train = y.iloc[
                train_index
            ]

            y_test = y.iloc[
                test_index
            ]

            predictions = {}

            for (
                model_name,
                alpha,
            ) in self.QUANTILES.items():

                model = self.build_model(
                    alpha
                )

                model.fit(
                    X_train,
                    y_train,
                )

                predictions[
                    model_name
                ] = model.predict(
                    X_test
                )

            result = evaluator.evaluate(
                horizon=self.horizon,
                actual=y_test,
                median_prediction=predictions[
                    "median"
                ],
                lower_prediction=predictions[
                    "lower"
                ],
                upper_prediction=predictions[
                    "upper"
                ],
            )

            fold_results.append(
                result
            )

        metrics = evaluator.average(
            fold_results
        )

        save_metrics(
            metrics
        )

        # --------------------------------------------------
        # Production models
        # --------------------------------------------------

        for (
            model_name,
            alpha,
        ) in self.QUANTILES.items():

            model = self.build_model(
                alpha
            )

            model.fit(
                X,
                y,
            )

            joblib.dump(
                model,
                self.model_directory
                / f"{model_name}.pkl",
            )

        print(
            f"Saved production models for "
            f"{self.horizon}"
        )

        return metrics

    # --------------------------------------------------
    # XGBoost
    # --------------------------------------------------

    @staticmethod
    def build_model(
        alpha: float,
    ):

        return XGBRegressor(
            objective="reg:quantileerror",

            quantile_alpha=alpha,

            n_estimators=500,

            learning_rate=0.03,

            max_depth=6,

            subsample=0.80,

            colsample_bytree=0.80,

            random_state=RANDOM_STATE,

            tree_method="hist",
        )