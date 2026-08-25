from __future__ import annotations

import sys

from app.data.loader import load_dataset
from app.jobs.backfill import HistoricalBackfill
from app.persistence.rails_client import (
    RailsForecastClient,
)


def main():

    start_date = (
        sys.argv[1]
        if len(sys.argv) > 1
        else "2026-05-13"
    )

    print(
        f"[PERSIST] Loading NAV dataset..."
    )

    dataframe = load_dataset()

    print(
        f"[PERSIST] Loaded "
        f"{len(dataframe)} NAV rows."
    )

    print(
        f"[PERSIST] Running historical "
        f"backfill from {start_date}..."
    )

    backfill = HistoricalBackfill(
        dataframe=dataframe,
        start_date=start_date,
    )

    forecasts = backfill.run()

    print(
        f"[PERSIST] Generated "
        f"{len(forecasts)} forecasts."
    )

    if not forecasts:
        print(
            "[PERSIST] Nothing to persist."
        )
        return

    print(
        "[PERSIST] Connecting to Rails..."
    )

    client = RailsForecastClient()

    result = client.persist_forecasts(
        forecasts
    )

    print()
    print(
        "[PERSIST] Rails persistence complete."
    )

    print(
        f"[PERSIST] Received: "
        f"{result.get('received', 0)}"
    )

    print(
        f"[PERSIST] Created: "
        f"{result.get('created', 0)}"
    )

    print(
        f"[PERSIST] Updated: "
        f"{result.get('updated', 0)}"
    )


if __name__ == "__main__":
    main()