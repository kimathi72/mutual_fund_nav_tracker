from __future__ import annotations

import pandas as pd

from app.config import (
    FEATURE_COLUMNS,
    TARGET_COLUMNS,
)

from app.data.feature_builder import (
    build_features,
)

from app.data.target_builder import (
    TargetBuilder,
)


class TrainingFrameBuilder:
    """
    Builds the supervised-learning dataframe for one forecast horizon.

    Pipeline:

        raw NAV dataset
              |
              +----> feature_builder
              |
              +----> target_builder
              |
              +----> merge on (isin, nav_date)
              |
              +----> drop incomplete rows
              |
              +----> training frame

    Targets are generated in Python from the NAV history.

    The target_* columns that may already exist in the Rails CSV
    are deliberately ignored. This prevents stale/incomplete
    Rails targets from affecting model training.
    """

    def __init__(
        self,
        dataframe: pd.DataFrame,
    ):
        self.dataframe = dataframe.copy()

    def build(
        self,
        horizon: str,
    ) -> pd.DataFrame:

        if horizon not in TARGET_COLUMNS:
            raise ValueError(
                f"Unsupported horizon: {horizon}. "
                f"Supported horizons: "
                f"{list(TARGET_COLUMNS.keys())}"
            )

        target_column = TARGET_COLUMNS[horizon]

        # --------------------------------------------------
        # Build features.
        #
        # build_features() removes any existing target
        # columns before calculating the features.
        # --------------------------------------------------

        features = build_features(
            self.dataframe
        )

        if features.empty:
            return pd.DataFrame(
                columns=[
                    "isin",
                    "nav_date",
                    *FEATURE_COLUMNS,
                    target_column,
                ]
            )

        # --------------------------------------------------
        # Build authoritative future targets from the raw
        # NAV observations.
        #
        # 1d  = next observation
        # 30d = 30th subsequent observation
        # 90d = 90th subsequent observation
        # --------------------------------------------------

        targets = (
            TargetBuilder(
                self.dataframe
            )
            .build_all()
        )

        target_frame = targets[
            [
                "isin",
                "nav_date",
                target_column,
            ]
        ].copy()

        # --------------------------------------------------
        # Join features to targets.
        # --------------------------------------------------

        frame = features.merge(
            target_frame,
            on=[
                "isin",
                "nav_date",
            ],
            how="left",
        )

        # --------------------------------------------------
        # Only observations with:
        #
        #   - complete features
        #   - known future target
        #
        # are usable for supervised training.
        # --------------------------------------------------

        frame = frame.dropna(
            subset=[
                *FEATURE_COLUMNS,
                target_column,
            ]
        )

        return (
            frame
            .sort_values(
                [
                    "isin",
                    "nav_date",
                ]
            )
            .reset_index(drop=True)
        )
