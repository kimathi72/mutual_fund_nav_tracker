from __future__ import annotations

import os
from typing import Dict, List

import requests


class RailsScoringClient:
    """
    Communicates with Rails for forecast scoring.

    Python:
        - retrieves unscored forecasts
        - calculates scoring metrics
        - sends scoring results

    Rails:
        - remains the system of record
        - persists scoring results
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

        self.unscored_endpoint = (
            f"{self.base_url}"
            "/api/v1/ml/forecasts/unscored"
        )

        self.score_endpoint = (
            f"{self.base_url}"
            "/api/v1/ml/forecasts/score"
        )

    def fetch_unscored_forecasts(
        self,
    ) -> List[Dict]:

        response = requests.get(
            self.unscored_endpoint,
            timeout=self.timeout,
        )

        response.raise_for_status()

        payload = response.json()

        return payload.get(
            "forecasts",
            []
        )

    def persist_scores(
        self,
        forecasts: List[Dict],
    ) -> Dict:

        if not forecasts:
            return {
                "success": True,
                "received": 0,
                "updated": 0,
            }

        response = requests.patch(
            self.score_endpoint,
            json={
                "forecasts": forecasts,
            },
            timeout=self.timeout,
        )

        response.raise_for_status()

        return response.json()