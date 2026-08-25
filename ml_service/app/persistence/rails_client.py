from __future__ import annotations

import os
from typing import Dict, List

import requests


class RailsForecastClient:
    """
    Persists ML forecasts into the Rails application.

    Python does not connect directly to PostgreSQL.
    Rails remains the system of record.
    """

    def __init__(
        self,
        base_url: str | None = None,
        timeout: int = 30,
    ):
        self.base_url = (
            base_url
            or os.getenv(
                "RAILS_API_URL",
                "http://web:3000",
            )
        ).rstrip("/")

        self.timeout = timeout

        self.endpoint = (
            f"{self.base_url}"
            "/api/v1/ml/forecasts/bulk"
        )

    def persist_forecasts(
        self,
        forecasts: List[Dict],
    ) -> Dict:

        if not forecasts:
            return {
                "success": True,
                "received": 0,
                "created": 0,
                "updated": 0,
            }

        response = requests.post(
            self.endpoint,
            json={
                "forecasts": forecasts,
            },
            timeout=self.timeout,
        )

        response.raise_for_status()

        return response.json()