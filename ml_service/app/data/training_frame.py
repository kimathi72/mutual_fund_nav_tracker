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
    Builds the supervised-learning dataframe for one horizon.

    Pipeline:

        NAV CSV
          ↓
        features
          ↓
        all future targets
          ↓
        select requested horizon
          ↓
        drop rows without known targets
          ↓
        Trainer
    """

    def __init__(
        self,
        dataframe: pd.DataFrame,
    ):
        self.dataframe = dataframe.copy()

    # --------------------------------------------------
    # Build
    # --------------------------------------------------

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

        target_column = TARGET_COLUMNS[
            horizon
        ]

        # --------------------------------------------------
        # Features
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
        # Targets
        #
        # Build ALL targets once, then select the
        # requested horizon.
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
        # Join features + selected target
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
        # Only rows with complete features and a known
        # future target can train the model.
        #
        # The final:
        #
        #   1 observation for 1d
        #   30 observations for 30d
        #   90 observations for 90d
        #
        # naturally have NULL targets.
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