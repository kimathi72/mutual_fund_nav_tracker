from __future__ import annotations

from app.config import (
    MODEL_DIR,
    HORIZONS,
)

from app.data.loader import load_dataset
from app.data.training_frame import TrainingFrameBuilder
from app.models.trainer import Trainer


def main():

    dataframe = load_dataset()

    frame_builder = TrainingFrameBuilder(
        dataframe
    )

    results = []

    for horizon_name in HORIZONS:

        print()
        print("=" * 80)
        print(
            f"BUILDING TRAINING FRAME: {horizon_name}"
        )
        print("=" * 80)

        training_frame = frame_builder.build(
            horizon_name
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

        model_directory = (
            MODEL_DIR
            / horizon_name
        )

        trainer = Trainer(
            dataframe=training_frame,
            model_directory=model_directory,
        )

        metrics = trainer.train()

        results.append(
            metrics
        )

    return results


if __name__ == "__main__":
    main()