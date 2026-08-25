from __future__ import annotations

import sys
from datetime import datetime, timezone
from typing import Dict, List

import pandas as pd

from app.data.loader import load_dataset
from app.persistence.rails_scoring_client import (
    RailsScoringClient,
)


HORIZONS = {
    "1d",
    "30d",
    "90d",
}


class ForecastScorer:
    """
    Scores persisted forecasts against actual NAV observations.

    A forecast becomes scoreable when its target_date
    exists in the NAV dataset.

    This job does NOT generate predictions.

    It only calculates:

        actual_nav
        absolute_error
        percentage_error
        direction_correct
        scored_at
    """

    def __init__(
        self,
        dataframe: pd.DataFrame,
    ):
        self.dataframe = dataframe.copy()

        self.dataframe["nav_date"] = pd.to_datetime(
            self.dataframe["nav_date"]
        )

        self.dataframe["nav"] = pd.to_numeric(
            self.dataframe["nav"],
            errors="coerce",
        )

        self.dataframe["isin"] = (
            self.dataframe["isin"]
            .astype(str)
            .str.strip()
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

    # --------------------------------------------------
    # Public API
    # --------------------------------------------------

    def score(
        self,
        forecasts: List[Dict],
    ) -> List[Dict]:

        results = []

        for forecast in forecasts:

            result = self.score_forecast(
                forecast
            )

            if result is not None:
                results.append(result)

        return results

    # --------------------------------------------------
    # Individual forecast
    # --------------------------------------------------

    def score_forecast(
        self,
        forecast: Dict,
    ) -> Dict | None:

        forecast_id = forecast.get(
            "forecast_id"
        )

        isin = forecast.get(
            "isin"
        )

        target_date = forecast.get(
            "target_date"
        )

        predicted_nav = forecast.get(
            "predicted_nav"
        )

        origin_nav = forecast.get(
            "origin_nav"
        )

        if not all(
            [
                forecast_id,
                isin,
                target_date,
                predicted_nav is not None,
            ]
        ):
            print(
                "[SCORING] Skipping malformed "
                f"forecast: {forecast}"
            )

            return None

        if forecast.get("horizon") not in HORIZONS:
            print(
                "[SCORING] Skipping unsupported "
                f"horizon: {forecast.get('horizon')}"
            )

            return None

        target_date = pd.Timestamp(
            target_date
        )

        actual = self.find_actual_nav(
            isin=isin,
            target_date=target_date,
        )

        if actual is None:

            print(
                "[SCORING] Target NAV not available | "
                f"forecast={forecast_id} | "
                f"isin={isin} | "
                f"target={target_date.date()}"
            )

            return None

        predicted_nav = float(
            predicted_nav
        )

        actual_nav = float(
            actual
        )

        absolute_error = abs(
            predicted_nav - actual_nav
        )

        percentage_error = (
            (
                absolute_error
                / abs(actual_nav)
            )
            * 100
            if actual_nav != 0
            else None
        )

        direction_correct = (
            self.calculate_direction(
                origin_nav=origin_nav,
                predicted_nav=predicted_nav,
                actual_nav=actual_nav,
            )
        )

        scored_at = datetime.now(
            timezone.utc
        ).isoformat()

        result = {
            "forecast_id": int(
                forecast_id
            ),
            "actual_nav": round(
                actual_nav,
                8,
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
            "direction_correct": (
                direction_correct
            ),
            "scored_at": scored_at,
        }

        print(
            "[SCORING] Forecast scored | "
            f"id={forecast_id} | "
            f"isin={isin} | "
            f"horizon={forecast.get('horizon')} | "
            f"predicted={predicted_nav:.8f} | "
            f"actual={actual_nav:.8f} | "
            f"error={percentage_error:.4f}%"
            if percentage_error is not None
            else
            "[SCORING] Forecast scored | "
            f"id={forecast_id} | "
            f"isin={isin} | "
            f"actual={actual_nav:.8f}"
        )

        return result

    # --------------------------------------------------
    # Actual NAV
    # --------------------------------------------------

    def find_actual_nav(
        self,
        isin: str,
        target_date: pd.Timestamp,
    ) -> float | None:

        matches = self.dataframe[
            (
                self.dataframe["isin"]
                == isin
            )
            &
            (
                self.dataframe["nav_date"]
                == target_date
            )
        ]

        if matches.empty:
            return None

        return float(
            matches.iloc[0]["nav"]
        )

    # --------------------------------------------------
    # Direction
    # --------------------------------------------------

    @staticmethod
    def calculate_direction(
        origin_nav,
        predicted_nav,
        actual_nav,
    ) -> bool | None:

        if origin_nav is None:
            return None

        origin_nav = float(
            origin_nav
        )

        predicted_nav = float(
            predicted_nav
        )

        actual_nav = float(
            actual_nav
        )

        predicted_direction = (
            predicted_nav > origin_nav
        )

        actual_direction = (
            actual_nav > origin_nav
        )

        # Flat prediction and flat actual
        # count as directionally correct.
        if (
            predicted_nav == origin_nav
            and actual_nav == origin_nav
        ):
            return True

        return (
            predicted_direction
            == actual_direction
        )


def main():

    print(
        "[SCORING] Loading NAV dataset..."
    )

    dataframe = load_dataset()

    print(
        "[SCORING] Loaded "
        f"{len(dataframe)} NAV rows."
    )

    # --------------------------------------------------
    # IMPORTANT:
    #
    # The actual Forecast records are currently
    # persisted in Rails.
    #
    # We therefore need Rails to provide the
    # unscored forecasts.
    # --------------------------------------------------

    print(
        "[SCORING] Fetching unscored forecasts..."
    )

    client = RailsScoringClient()

    forecasts = client.fetch_unscored_forecasts()

    print(
        "[SCORING] Received "
        f"{len(forecasts)} unscored forecasts."
    )

    if not forecasts:
        print(
            "[SCORING] Nothing to score."
        )
        return

    scorer = ForecastScorer(
        dataframe
    )

    scores = scorer.score(
        forecasts
    )

    print(
        "[SCORING] Scoreable forecasts: "
        f"{len(scores)}"
    )

    if not scores:
        print(
            "[SCORING] No forecasts have "
            "available target NAVs yet."
        )
        return

    result = client.persist_scores(
        scores
    )

    print()
    print(
        "[SCORING] Persistence complete."
    )

    print(
        f"[SCORING] Received: "
        f"{result.get('received', 0)}"
    )

    print(
        f"[SCORING] Updated: "
        f"{result.get('updated', 0)}"
    )


if __name__ == "__main__":
    main()