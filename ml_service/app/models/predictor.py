from __future__ import annotations

from pathlib import Path

import joblib
import pandas as pd

from app.data.feature_builder import (
    build_prediction_features,
)
from app.horizons import HORIZONS


class Predictor:
    """
    Loads trained quantile models and generates
    forecasts for every configured horizon.

    Horizons are measured in NAV observations,
    not calendar days.
    """

    MODEL_VERSION = "xgboost-q-v3"

    def __init__(
        self,
        model_root: str = "models",
    ):
        self.model_root = Path(model_root)
        self.cache = {}

    def _load_model(
        self,
        horizon_name: str,
        quantile: str,
    ):
        key = (
            horizon_name,
            quantile,
        )

        if key not in self.cache:
            path = (
                self.model_root
                / horizon_name
                / f"{quantile}.pkl"
            )

            if not path.exists():
                raise FileNotFoundError(
                    f"Model not found: {path}"
                )

            self.cache[key] = joblib.load(path)

        return self.cache[key]

    def predict_horizon(
        self,
        history: pd.DataFrame,
        horizon,
    ):
        history = (
            history
            .copy()
            .sort_values("nav_date")
            .reset_index(drop=True)
        )

        features = build_prediction_features(history)

        if features.empty:
            raise ValueError(
                f"Insufficient history for "
                f"{horizon.NAME} forecast"
            )

        X = features.tail(1)

        latest_nav = float(
            history.iloc[-1]["nav"]
        )

        target_index = (
            len(history)
            - 1
            + horizon.TARGET_OBSERVATIONS
        )

        # For a live forecast, the future
        # observation does not exist yet.
        target_date = None

        if target_index < len(history):
            target_date = (
                pd.Timestamp(
                    history.iloc[target_index]["nav_date"]
                )
                .date()
                .isoformat()
            )

        lower = float(
            self._load_model(
                horizon.NAME,
                "lower",
            ).predict(X)[0]
        )

        median = float(
            self._load_model(
                horizon.NAME,
                "median",
            ).predict(X)[0]
        )

        upper = float(
            self._load_model(
                horizon.NAME,
                "upper",
            ).predict(X)[0]
        )

        # Protect against quantile crossing.
        lower, median, upper = sorted(
            [
                lower,
                median,
                upper,
            ]
        )

        confidence = self._confidence(
            median,
            lower,
            upper,
        )

        expected_return = (
            (
                median - latest_nav
            )
            / latest_nav
        ) * 100

        return {
            "horizon": horizon.NAME,

            "target_observations": (
                horizon.TARGET_OBSERVATIONS
            ),

            "target_date": target_date,

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

            "confidence_score": confidence,

            "expected_return_pct": round(
                expected_return,
                4,
            ),

            "model_version": (
                self.MODEL_VERSION
            ),
        }

    def predict_all(
        self,
        history: pd.DataFrame,
    ):
        forecasts = []

        for horizon in HORIZONS:

            # HORIZON IS AN OBJECT.
            # The model directory uses its NAME:
            #
            # models/1d
            # models/30d
            # models/90d
            #
            horizon_name = horizon.NAME

            model_path = (
                self.model_root
                / horizon_name
            )

            if not model_path.exists():
                print(
                    f"Skipping {horizon_name}: "
                    "no trained model."
                )
                continue

            forecasts.append(
                self.predict_horizon(
                    history,
                    horizon,
                )
            )

        return forecasts

    @staticmethod
    def _confidence(
        prediction: float,
        lower: float,
        upper: float,
    ):
        width = (
            upper - lower
        )

        if prediction == 0:
            return 0.0

        relative_width = (
            abs(width / prediction)
        )

        confidence = max(
            0.0,
            min(
                1.0,
                1.0 - relative_width,
            ),
        )

        return round(
            confidence,
            4,
        )
