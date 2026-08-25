from __future__ import annotations

from typing import Dict
from typing import List

import pandas as pd

from app.data.loader import (
    load_dataset,
    load_single_fund,
)

from app.services.prediction_service import PredictionService


class ForecastService:
    """
    High-level forecasting service.

    Responsibilities
    ----------------
    • Forecast a single fund
    • Forecast the entire portfolio
    """

    def __init__(self):
        self.prediction_service = PredictionService()

    # ---------------------------------------------------------
    # Single fund
    # ---------------------------------------------------------

    def forecast(
        self,
        dataframe: pd.DataFrame,
        isin: str,
    ) -> Dict:

        result = self.prediction_service.predict(
            history=dataframe
        )

        return {
            "success": True,
            "isin": isin,
            "generated_at": result["generated_at"],
            "predictions": result["predictions"],
        }

    # ---------------------------------------------------------
    # Entire portfolio
    # ---------------------------------------------------------

    def forecast_portfolio(self) -> List[Dict]:

        dataframe = load_dataset()

        forecasts = []

        for isin in sorted(dataframe["isin"].unique()):

            history = load_single_fund(
                dataframe,
                isin,
            )

            forecasts.append(
                self.forecast(
                    history,
                    isin,
                )
            )

        return forecasts