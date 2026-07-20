from __future__ import annotations

import pandas as pd

from app.models.predictor import Predictor


class PredictionService:
    """
    High-level service used by the API.

    Receives a dataframe for one fund and returns
    forecasts for every configured horizon.
    """

    def __init__(self):
        self.predictor = Predictor()

    def predict(
        self,
        history: pd.DataFrame,
    ) -> dict:

        forecasts = self.predictor.predict_all(
            history
        )

        return {
            "generated_at": pd.Timestamp.utcnow().isoformat(),
            "predictions": forecasts,
        }