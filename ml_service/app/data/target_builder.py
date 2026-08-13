from __future__ import annotations

import pandas as pd

from app.config import (
    HORIZONS,
    TARGET_COLUMNS,
)


class TargetBuilder:
    """
    Builds supervised-learning targets using trading observations.

    Horizons are observation-based, not calendar-day based.

        target_nav_1d  = next NAV observation
        target_nav_30d = 30th subsequent NAV observation
        target_nav_90d = 90th subsequent NAV observation

    Each ISIN is shifted independently.

    No calendar arithmetic is used.
    """

    def __init__(
        self,
        dataframe: pd.DataFrame,
    ):
        self.df = dataframe.copy()

    # --------------------------------------------------
    # Build all targets
    # --------------------------------------------------

    def build_all(self) -> pd.DataFrame:
        """
        Build all configured forecast targets.

        Returns the original dataset plus:

            target_nav_1d
            target_nav_30d
            target_nav_90d
        """

        df = self.df.copy()

        if "date" in df.columns and "nav_date" not in df.columns:
            df = df.rename(
                columns={
                    "date": "nav_date",
                }
            )

        df["nav_date"] = pd.to_datetime(
            df["nav_date"],
            errors="coerce",
        )

        df["nav"] = pd.to_numeric(
            df["nav"],
            errors="coerce",
        )

        df = (
            df
            .dropna(
                subset=[
                    "isin",
                    "nav_date",
                    "nav",
                ]
            )
            .sort_values(
                [
                    "isin",
                    "nav_date",
                ]
            )
            .reset_index(drop=True)
        )

        # --------------------------------------------------
        # Build future NAV targets independently per fund.
        #
        # shift(-1)  = next trading observation
        # shift(-30) = 30th subsequent observation
        # shift(-90) = 90th subsequent observation
        # --------------------------------------------------

        grouped_nav = df.groupby(
            "isin",
            sort=False,
        )["nav"]

        for horizon, observations in HORIZONS.items():

            target_column = TARGET_COLUMNS[horizon]

            df[target_column] = (
                grouped_nav.shift(
                    -observations
                )
            )

        return df

    # --------------------------------------------------
    # Backward-compatible alias
    # --------------------------------------------------

    def build(self) -> pd.DataFrame:
        """
        Backward-compatible alias for build_all().
        """

        return self.build_all()

    # --------------------------------------------------
    # Single horizon
    # --------------------------------------------------

    def build_for_horizon(
        self,
        horizon: str,
    ) -> pd.DataFrame:
        """
        Build targets and return only the target requested.
        """

        if horizon not in HORIZONS:
            raise ValueError(
                f"Unsupported horizon: {horizon}. "
                f"Supported horizons: {list(HORIZONS.keys())}"
            )

        target_column = TARGET_COLUMNS[horizon]

        df = self.build_all()

        return df[
            [
                "isin",
                "nav_date",
                "nav",
                target_column,
            ]
        ].copy()