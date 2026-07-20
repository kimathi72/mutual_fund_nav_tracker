from __future__ import annotations

import logging

from app.data.loader import load_dataset
from app.services.training_service import TrainingService

logging.basicConfig(level=logging.INFO)

logger = logging.getLogger(__name__)


def main():

    logger.info("Loading dataset...")

    dataframe = load_dataset()

    logger.info(
        "Dataset contains %s rows.",
        len(dataframe),
    )

    trainer = TrainingService(
        dataframe
    )

    summary = trainer.train_all()

    logger.info(
        "=================================="
    )

    logger.info(
        "Training completed."
    )

    logger.info(
        "%s horizons trained.",
        len(summary),
    )

    logger.info(
        "=================================="
    )

    return summary


if __name__ == "__main__":
    main()