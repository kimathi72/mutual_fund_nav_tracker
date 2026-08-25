from __future__ import annotations

from typing import Dict, List

import pandas as pd
from xgboost import XGBRegressor

from app.config import (
    FEATURE_COLUMNS,
    HORIZONS,
    QUANTILES,
    RANDOM_STATE,
)
from app.data.feature_builder import build_features


class HistoricalBackfill:
    """
    Generates historical forecasts without look-ahead leakage.

    For every forecast origin:

        available history
            ->
        historical training rows
            ->
        quantile models
            ->
        forecast
            ->
        actual NAV
            ->
        scoring metrics

    Horizons are measured in NAV observations.
    """

    MODEL_VERSION = "xgboost-q-v3-backfill"

    MINIMUM_TRAINING_ROWS = 30

    def __init__(
        self,
        dataframe: pd.DataFrame,
        start_date: str,
    ):
        self.dataframe = dataframe.copy()

        self.start_date = pd.Timestamp(start_date)

        self.dataframe["nav_date"] = pd.to_datetime(
            self.dataframe["nav_date"]
        )

        self.dataframe["nav"] = pd.to_numeric(
            self.dataframe["nav"],
            errors="coerce",
        )

        self.dataframe = (
            self.dataframe
            .dropna(
                subset=[
                    "isin",
                    "nav_date",
                    "nav",
                ]
            )
            .sort_values(
                [
                    "isin",
                    "nav_date",
                ]
            )
            .reset_index(drop=True)
        )

    # =========================================================
    # Public API
    # =========================================================

    def run(self) -> List[Dict]:

        results = []

        funds = list(
            self.dataframe.groupby(
                "isin",
                sort=True,
            )
        )

        total_funds = len(funds)

        print(
            f"[BACKFILL] Starting historical backfill"
        )

        print(
            f"[BACKFILL] Start date: "
            f"{self.start_date.date()}"
        )

        print(
            f"[BACKFILL] Funds: {total_funds}"
        )

        print(
            f"[BACKFILL] Horizons: "
            f"{list(HORIZONS.keys())}"
        )

        print(
            f"[BACKFILL] "
            f"Rows: {len(self.dataframe)}"
        )

        for fund_number, (isin, history) in enumerate(
            funds,
            start=1,
        ):

            print()
            print("=" * 80)

            print(
                f"[BACKFILL] FUND "
                f"{fund_number}/{total_funds}: "
                f"{isin}"
            )

            print("=" * 80)

            history = (
                history
                .sort_values("nav_date")
                .reset_index(drop=True)
            )

            print(
                f"[BACKFILL] NAV observations: "
                f"{len(history)}"
            )

            fund_results = self.backfill_fund(
                isin=isin,
                history=history,
            )

            results.extend(fund_results)

            print(
                f"[BACKFILL] Completed {isin}: "
                f"{len(fund_results)} forecasts"
            )

        print()
        print("=" * 80)

        print(
            f"[BACKFILL] COMPLETE"
        )

        print(
            f"[BACKFILL] Total forecasts: "
            f"{len(results)}"
        )

        print("=" * 80)

        return results

    # =========================================================
    # Fund
    # =========================================================

    def backfill_fund(
        self,
        *,
        isin: str,
        history: pd.DataFrame,
    ) -> List[Dict]:

        features = build_features(
            history.assign(isin=isin)
        )

        if features.empty:
            print(
                f"[BACKFILL] {isin}: "
                f"no feature rows"
            )

            return []

        results = []

        for horizon_name, horizon_observations in HORIZONS.items():

            print()
            print(
                f"[BACKFILL] {isin} "
                f"| Horizon {horizon_name} "
                f"| {horizon_observations} observations"
            )

            horizon_results = self.backfill_horizon(
                isin=isin,
                history=history,
                features=features,
                horizon_name=horizon_name,
                horizon_observations=horizon_observations,
                minimum_training_rows=self.MINIMUM_TRAINING_ROWS,
            )

            results.extend(
                horizon_results
            )

        return results

    # =========================================================
    # Horizon
    # =========================================================

    def backfill_horizon(
        self,
        *,
        isin: str,
        history: pd.DataFrame,
        features: pd.DataFrame,
        horizon_name: str,
        horizon_observations: int,
        minimum_training_rows: int,
    ) -> List[Dict]:

        results = []

        feature_rows = (
            features[
                features["isin"] == isin
            ]
            .sort_values("nav_date")
            .reset_index(drop=True)
        )

        total_origins = len(feature_rows)

        completed = 0
        skipped = 0

        for origin_index in range(
            minimum_training_rows,
            total_origins,
        ):

            origin = feature_rows.iloc[
                origin_index
            ]

            origin_date = pd.Timestamp(
                origin["nav_date"]
            )

            if origin_date < self.start_date:
                continue

            target_index = (
                origin_index
                + horizon_observations
            )

            # We cannot score a forecast unless
            # the actual future NAV exists.
            if target_index >= total_origins:
                skipped += 1

                continue

            train_end_index = (
                origin_index
                - horizon_observations
            )

            if train_end_index <= 0:
                skipped += 1

                continue

            training_features = (
                feature_rows
                .iloc[
                    :train_end_index + 1
                ]
                .copy()
            )

            training_features[
                "target"
            ] = (
                feature_rows["nav"]
                .shift(
                    -horizon_observations
                )
                .iloc[
                    :train_end_index + 1
                ]
                .values
            )

            training_features = (
                training_features
                .dropna(
                    subset=[
                        "target",
                        *FEATURE_COLUMNS,
                    ]
                )
            )

            if len(training_features) < minimum_training_rows:

                skipped += 1

                continue

            print(
                f"[BACKFILL] "
                f"{isin} "
                f"| {horizon_name} "
                f"| origin "
                f"{origin_index + 1}/{total_origins} "
                f"| {origin_date.date()} "
                f"| train={len(training_features)}",
                flush=True,
            )

            X_train = training_features[
                FEATURE_COLUMNS
            ]

            y_train = training_features[
                "target"
            ]

            X_origin = pd.DataFrame(
                [
                    origin[
                        FEATURE_COLUMNS
                    ].to_dict()
                ]
            )

            models = {}

            for model_name, quantile in QUANTILES.items():

                print(
                    f"[BACKFILL]   training "
                    f"{model_name} "
                    f"(q={quantile})...",
                    flush=True,
                )

                model = self.build_model(
                    quantile
                )

                model.fit(
                    X_train,
                    y_train,
                )

                models[
                    model_name
                ] = model

                print(
                    f"[BACKFILL]   {model_name} "
                    f"complete",
                    flush=True,
                )

            lower = float(
                models["lower"]
                .predict(X_origin)[0]
            )

            median = float(
                models["median"]
                .predict(X_origin)[0]
            )

            upper = float(
                models["upper"]
                .predict(X_origin)[0]
            )

            lower, median, upper = sorted(
                [
                    lower,
                    median,
                    upper,
                ]
            )

            actual = float(
                feature_rows.iloc[
                    target_index
                ]["nav"]
            )

            target_date = pd.Timestamp(
                feature_rows.iloc[
                    target_index
                ]["nav_date"]
            )

            latest_nav = float(
                origin["nav"]
            )

            expected_return_pct = (
                (
                    median - latest_nav
                )
                / latest_nav
            ) * 100

            absolute_error = abs(
                median - actual
            )

            percentage_error = (
                absolute_error
                / abs(actual)
            ) * 100 if actual != 0 else None

            interval_hit = (
                lower
                <= actual
                <= upper
            )

            results.append(
                {
                    "isin": isin,

                    "horizon": horizon_name,

                    "target_observations": horizon_observations,

                    # The forecast was made using information
                    # available on this date.
                    "predicted_at": (
                        origin_date
                        .date()
                        .isoformat()
                    ),

                    # The future NAV observation against which
                    # the prediction is evaluated.
                    "target_date": (
                        target_date
                        .date()
                        .isoformat()
                    ),

                    "predicted_nav": round(
                        median,
                        8,
                    ),

                    "lower_bound": round(
                        lower,
                        8,
                    ),

                    "upper_bound": round(
                        upper,
                        8,
                    ),

                    "actual_nav": round(
                        actual,
                        8,
                    ),

                    "expected_return_pct": round(
                        expected_return_pct,
                        4,
                    ),

                    "absolute_error": round(
                        absolute_error,
                        8,
                    ),

                    "percentage_error": (
                        round(
                            percentage_error,
                            4,
                        )
                        if percentage_error is not None
                        else None
                    ),

                    "interval_hit": bool(
                        interval_hit
                    ),

                    "model_version": (
                        "xgboost-q-v3-backfill"
                    ),
                }
            )

            completed += 1

            print(
                f"[BACKFILL]   forecast complete "
                f"| predicted={median:.8f} "
                f"| actual={actual:.8f} "
                f"| error={percentage_error:.4f}%"
                if percentage_error is not None
                else
                f"[BACKFILL]   forecast complete "
                f"| predicted={median:.8f} "
                f"| actual={actual:.8f}",
                flush=True,
            )

        print(
            f"[BACKFILL] {isin} "
            f"| {horizon_name} COMPLETE "
            f"| forecasts={completed} "
            f"| skipped={skipped}",
            flush=True,
        )

        return results

    # =========================================================
    # Model
    # =========================================================

    @staticmethod
    def build_model(
        quantile: float,
    ):

        return XGBRegressor(
            objective="reg:quantileerror",
            quantile_alpha=quantile,
            n_estimators=500,
            learning_rate=0.03,
            max_depth=6,
            subsample=0.80,
            colsample_bytree=0.80,
            random_state=RANDOM_STATE,
            tree_method="hist",
            n_jobs=-1,
            verbosity=1,
        )