from __future__ import annotations

import pandas as pd

from pathlib import Path

from app.data.validation import validate_dataset

from app.horizons import HORIZONS

from app.models.trainer import Trainer

from app.utils.persistence import (
    save_training_summary,
    save_latest_training,
)


class TrainingService:
    """
    Trains every forecasting horizon.

    Produces

        models/
            1d/
            30d/
            90d/
            365d/

        artifacts/
            metrics/
                1d_metrics.json
                30d_metrics.json
                90d_metrics.json
                365d_metrics.json

            reports/
                training_summary.json
                latest_training.json
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

    def train_all(self):

        summary = []

        for horizon in HORIZONS:

            print(
                f"\n=============================="
            )

            print(
                f"Training {horizon.NAME}"
            )

            print(
                f"=============================="
            )

            training_frame = (
                horizon.build_training_frame(
                    self.dataframe
                )
            )
            if training_frame.empty:
                print(
                    f"Skipping {horizon.NAME}: insufficient training data."
                )
                continue

            trainer = Trainer(
                dataframe=training_frame,
                model_directory=Path("models")
                / horizon.NAME,
            )

            metrics = trainer.train()

            summary.append(
                {
                    "horizon": metrics.horizon,
                    "model_version": metrics.model_version,
                    "trained_at": metrics.trained_at,
                    "sample_count": metrics.sample_count,
                    "rmse": metrics.rmse,
                    "mae": metrics.mae,
                    "mape": metrics.mape,
                    "r2": metrics.r2,
                    "prediction_interval_coverage":
                        metrics.prediction_interval_coverage,
                    "average_interval_width":
                        metrics.average_interval_width,
                    "confidence_score":
                        metrics.confidence_score,
                }
            )

        save_training_summary(
            summary
        )

        save_latest_training(
            summary
        )

        return summary