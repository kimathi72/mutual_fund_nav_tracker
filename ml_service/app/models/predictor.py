from __future__ import annotations

from datetime import date
from datetime import timedelta
from pathlib import Path

import joblib
import pandas as pd

from app.data.feature_builder import build_prediction_features
from app.horizons import HORIZONS

from app.data.loader import load_dataset, load_single_fund

class Predictor:
    """
    Loads trained quantile models and generates
    forecasts for every configured horizon.
    """

    MODEL_VERSION = "xgboost-v2"

    def __init__(
        self,
        model_root: str = "models",
    ):

        self.model_root = Path(model_root)

        self.cache = {}

    # ----------------------------------------------------
    # Model Loader
    # ----------------------------------------------------

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

            self.cache[key] = joblib.load(path)

        return self.cache[key]

    # ----------------------------------------------------
    # Single Horizon Prediction
    # ----------------------------------------------------

    def predict_horizon(
        self,
        history: pd.DataFrame,
        horizon,
    ):

        features = build_prediction_features(
            history
        )

        X = features.tail(1)

        latest_nav = float(
            history.iloc[-1]["nav"]
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

        confidence = self._confidence(
            median,
            lower,
            upper,
        )

        expected_return = (
            (
                median
                - latest_nav
            )
            / latest_nav
        ) * 100

        return {

            "horizon": horizon.NAME,

            "target_days": horizon.TARGET_DAYS,

            "target_date": (
                date.today()
                + timedelta(
                    days=horizon.TARGET_DAYS
                )
            ).isoformat(),

            "predicted_nav": round(
                median,
                4,
            ),

            "lower_bound": round(
                lower,
                4,
            ),

            "upper_bound": round(
                upper,
                4,
            ),

            "confidence_score": confidence,

            "expected_return_pct": round(
                expected_return,
                2,
            ),

            "model_version": self.MODEL_VERSION,
        }

    # ----------------------------------------------------
    # Predict Every Horizon
    # ----------------------------------------------------

    def predict_all(
        self,
        history: pd.DataFrame,
    ):

        forecasts = []

        for horizon in HORIZONS:
            model_path = self.model_root / horizon.NAME

            if not model_path.exists():
                print(
                    f"Skipping {horizon.NAME}: no trained model."
                )
                continue
            forecasts.append(

                self.predict_horizon(
                    history,
                    horizon,
                )

            )

        return forecasts

    # ----------------------------------------------------
    # Confidence
    # ----------------------------------------------------

    @staticmethod
    def _confidence(
        prediction: float,
        lower: float,
        upper: float,
    ) -> float:

        width = upper - lower

        if prediction == 0:

            return 0.0

        relative_width = abs(
            width / prediction
        )

        confidence = max(
            0.0,
            1.0 - relative_width,
        )

        return round(
            confidence,
            4,
        )

                
    def predict(self, isin: str):
        dataframe = load_dataset()
        history = load_single_fund(dataframe, isin)
        return self.predict_all(history)