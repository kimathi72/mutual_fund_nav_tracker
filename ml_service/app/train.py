from __future__ import annotations

import logging

from app.data.loader import load_dataset

from app.services.training_service import (
    TrainingService,
)


logging.basicConfig(
    level=logging.INFO,
)

logger = logging.getLogger(__name__)


def main():

    logger.info(
        "======================================"
    )

    logger.info(
        "Loading historical NAV dataset..."
    )

    dataframe = load_dataset()

    logger.info(
        "Loaded %s rows.",
        len(dataframe),
    )

    logger.info(
        "======================================"
    )

    service = TrainingService(
        dataframe
    )

    summary = service.train_all()

    logger.info(
        "======================================"
    )

    logger.info(
        "Training completed successfully."
    )

    logger.info(
        "%s horizons trained.",
        len(summary),
    )

    logger.info(
        "Reports generated:"
    )

    logger.info(
        "artifacts/metrics/reports/training_summary.json"
    )

    logger.info(
        "artifacts/metrics/reports/latest_training.json"
    )

    logger.info(
        "======================================"
    )


if __name__ == "__main__":
    main()