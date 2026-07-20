from __future__ import annotations

from pathlib import Path

import joblib
import pandas as pd

from sklearn.model_selection import TimeSeriesSplit

from xgboost import XGBRegressor

from app.config import (
    FEATURE_COLUMNS,
    TARGET_COLUMN,
    RANDOM_STATE,
)

from app.models.evaluator import (
    Evaluator,
)

from app.utils.persistence import (
    save_metrics,
)


class Trainer:
    """
    Trains three quantile XGBoost models
    (lower, median, upper) using
    TimeSeries cross validation.
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

        self.df = dataframe

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

    # --------------------------------------------------

    def train(self):

        X = self.df[
            FEATURE_COLUMNS
        ]

        y = self.df[
            TARGET_COLUMN
        ]
        print("=" * 80)
        print("Training horizon:", self.horizon)

        print("\nTarget statistics")
        print(y.describe())

        print("\nFirst targets")
        print(y.head())

        print("\nLast targets")
        print(y.tail())

        print("=" * 80)

        splitter = TimeSeriesSplit(
            n_splits=5,
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

            models = {}

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

                models[
                    model_name
                ] = model

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

        print(
            f"Saved metrics for {self.horizon}"
        )

        #
        # Retrain on the
        # full dataset.
        #

        final_models = {}

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

            final_models[
                model_name
            ] = model

        print(
            f"Saved production models for {self.horizon}"
        )

        return metrics

    # --------------------------------------------------

    def build_model(
        self,
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