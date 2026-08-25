from __future__ import annotations

import json
import sys

from app.data.loader import load_dataset
from app.jobs.backfill import HistoricalBackfill


DEFAULT_START_DATE = "2026-05-13"


def main():

    start_date = (
        sys.argv[1]
        if len(sys.argv) > 1
        else DEFAULT_START_DATE
    )

    print(
        f"Loading NAV dataset..."
    )

    dataframe = load_dataset()

    print(
        f"Loaded {len(dataframe)} NAV rows."
    )

    print(
        f"Starting historical backfill "
        f"from {start_date}..."
    )

    backfill = HistoricalBackfill(
        dataframe=dataframe,
        start_date=start_date,
    )

    results = backfill.run()

    print()
    print("=" * 80)
    print("BACKFILL COMPLETE")
    print("=" * 80)

    print(
        f"Start date: {start_date}"
    )

    print(
        f"Forecast count: {len(results)}"
    )

    if results:

        horizons = {}

        for result in results:

            horizon = result[
                "horizon"
            ]

            horizons[horizon] = (
                horizons.get(
                    horizon,
                    0,
                )
                + 1
            )

        print()
        print("Forecasts by horizon:")

        for horizon, count in sorted(
            horizons.items()
        ):
            print(
                f"  {horizon}: {count}"
            )

    print()

    print(
        json.dumps(
            {
                "success": True,
                "start_date": start_date,
                "forecast_count": len(results),
                "forecasts": results,
            },
            indent=2,
            default=str,
        )
    )


if __name__ == "__main__":
    main()