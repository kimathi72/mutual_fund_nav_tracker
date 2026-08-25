from __future__ import annotations

import logging
from datetime import datetime

from app.data.loader import load_dataset
from app.data.feature_builder import build_features
from app.data.target_builder import build_targets

from app.models.quantile_trainer import QuantileTrainer

logging.basicConfig(level=logging.INFO)

logger = logging.getLogger(__name__)


HORIZONS = (
    1,
    30,
    90,
    365,
)


def retrain_horizon(
    dataframe,
    horizon: int,
):

    logger.info(
        "Retraining %s-day model...",
        horizon,
    )

    dataset = build_targets(
        dataframe.copy(),
        horizon=horizon,
    )

    dataset = build_features(dataset)

    trainer = QuantileTrainer(
        horizon=horizon,
    )

    trainer.train(dataset)

    logger.info(
        "%s-day model updated.",
        horizon,
    )


def main():

    logger.info(
        "======================================"
    )

    logger.info(
        "Forecast retraining started."
    )

    logger.info(
        "Started at %s",
        datetime.utcnow(),
    )

    dataframe = load_dataset()

    for horizon in HORIZONS:

        retrain_horizon(
            dataframe,
            horizon,
        )

    logger.info(
        "Retraining completed."
    )

    logger.info(
        "Finished at %s",
        datetime.utcnow(),
    )

    logger.info(
        "======================================"
    )


if __name__ == "__main__":
    main()