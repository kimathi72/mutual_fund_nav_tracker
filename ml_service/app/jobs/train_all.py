from __future__ import annotations

from pathlib import Path

from app.config import (
    DATA_DIR,
    MODEL_DIR,
    HORIZONS,
)

from app.data.loader import load_dataset
from app.models.trainer import Trainer


def main():

    dataframe = load_dataset()

    results = []

    for horizon_name in HORIZONS:

        print()
        print("=" * 80)
        print(
            f"TRAINING HORIZON: {horizon_name}"
        )
        print("=" * 80)

        model_directory = (
            MODEL_DIR
            / horizon_name
        )

        trainer = Trainer(
            dataframe=dataframe,
            model_directory=model_directory,
            horizon=horizon_name,
        )

        metrics = trainer.train()

        results.append(
            metrics
        )

    return results


if __name__ == "__main__":
    main()