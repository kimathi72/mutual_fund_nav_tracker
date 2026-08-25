from __future__ import annotations

from pathlib import Path

import pandas as pd

from app.config import HORIZONS
from app.data.training_frame import TrainingFrameBuilder
from app.data.validation import validate_dataset
from app.models.trainer import Trainer
from app.utils.persistence import (
    save_latest_training,
    save_training_summary,
)


class TrainingService:
    """
    Trains all configured forecasting horizons.
    """

    def __init__(
        self,
        dataframe: pd.DataFrame,
    ):

        self.dataframe = dataframe.copy()

        validate_dataset(
            self.dataframe
        )

    # --------------------------------------------------
    # Train all horizons
    # --------------------------------------------------

    def train_all(self):

        summary = []

        frame_builder = (
            TrainingFrameBuilder(
                self.dataframe
            )
        )

        for horizon_name in HORIZONS:

            print()
            print("=" * 80)
            print(
                f"Building training frame: "
                f"{horizon_name}"
            )
            print("=" * 80)

            training_frame = (
                frame_builder.build(
                    horizon_name
                )
            )

            if training_frame.empty:

                print(
                    f"Skipping {horizon_name}: "
                    "insufficient training data."
                )

                continue

            print(
                f"{horizon_name}: "
                f"{len(training_frame)} rows"
            )

            trainer = Trainer(
                dataframe=training_frame,
                model_directory=(
                    Path("models")
                    / horizon_name
                ),
            )

            metrics = trainer.train()

            summary.append(
                metrics.to_dict()
            )

        save_training_summary(
            summary
        )

        save_latest_training(
            summary
        )

        return summary