from pathlib import Path
import os

import pandas as pd


class DatasetLoader:
    def load(self):
        dataset = os.getenv(
            "DATASET_PATH",
            "/app/exports/training_dataset.csv",
        )

        dataset = Path(dataset)

        if not dataset.exists():
            raise FileNotFoundError(
                f"Training dataset not found: {dataset}"
            )

        return pd.read_csv(dataset)