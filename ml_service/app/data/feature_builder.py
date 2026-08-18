from __future__ import annotations

import pandas as pd


FEATURE_COLUMNS = [
    "nav",
    "return_1d",
    "return_7d",
    "return_30d",
    "ma_7",
    "ma_30",
    "ma_90",
    "volatility_30",
    "momentum",
]


TARGET_COLUMNS = [
    "target_nav_1d",
    "target_nav_30d",
    "target_nav_90d",
]


def build_features(
    dataframe: pd.DataFrame,
) -> pd.DataFrame:
    """
    Build features independently for each mutual fund.

    Targets are explicitly removed before feature construction.
    Target values are generated separately by TargetBuilder.

    All features are calculated using observations available
    at the feature date or earlier.

    Returns are represented as decimal fractions.

    Example:

        1% return  -> 0.01
        -2% return -> -0.02
    """

    df = dataframe.copy()

    # --------------------------------------------------
    # IMPORTANT:
    # Target columns are NOT features.
    #
    # The Rails-exported dataset already contains target
    # columns, but TargetBuilder generates the authoritative
    # targets independently.
    #
    # Removing them here prevents merge collisions such as:
    #
    # target_nav_1d_x
    # target_nav_1d_y
    #
    # and prevents target leakage into the feature set.
    # --------------------------------------------------

    df = df.drop(
        columns=[
            column
            for column in TARGET_COLUMNS
            if column in df.columns
        ],
        errors="ignore",
    )

    # --------------------------------------------------
    # Normalize date column
    # --------------------------------------------------

    if (
        "date" in df.columns
        and "nav_date" not in df.columns
    ):
        df = df.rename(
            columns={
                "date": "nav_date",
            }
        )

    # --------------------------------------------------
    # Normalize types
    # --------------------------------------------------

    df["nav_date"] = pd.to_datetime(
        df["nav_date"],
        errors="coerce",
    )

    df["nav"] = pd.to_numeric(
        df["nav"],
        errors="coerce",
    )

    # --------------------------------------------------
    # Remove invalid NAV observations
    # --------------------------------------------------

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

    groups = []

    # --------------------------------------------------
    # Build features independently per fund
    # --------------------------------------------------

    for isin, fund in df.groupby(
        "isin",
        sort=False,
    ):

        fund = fund.copy()

        # --------------------------------------------------
        # Returns
        #
        # Decimal fractions, NOT percentages.
        #
        # Example:
        #   1%  ->  0.01
        #  -2%  -> -0.02
        # --------------------------------------------------

        fund["return_1d"] = (
            fund["nav"].pct_change(1)
        )

        fund["return_7d"] = (
            fund["nav"].pct_change(7)
        )

        fund["return_30d"] = (
            fund["nav"].pct_change(30)
        )

        # --------------------------------------------------
        # Moving averages
        # --------------------------------------------------

        fund["ma_7"] = (
            fund["nav"]
            .rolling(7)
            .mean()
        )

        fund["ma_30"] = (
            fund["nav"]
            .rolling(30)
            .mean()
        )

        fund["ma_90"] = (
            fund["nav"]
            .rolling(90)
            .mean()
        )

        # --------------------------------------------------
        # 30-observation volatility
        # --------------------------------------------------

        fund["volatility_30"] = (
            fund["return_1d"]
            .rolling(30)
            .std()
        )

        # --------------------------------------------------
        # 30-observation momentum
        # --------------------------------------------------

        fund["momentum"] = (
            fund["nav"]
            - fund["nav"].shift(30)
        )

        groups.append(fund)

    # --------------------------------------------------
    # No funds / no observations
    # --------------------------------------------------

    if not groups:
        return pd.DataFrame(
            columns=[
                "isin",
                "nav_date",
                *FEATURE_COLUMNS,
            ]
        )

    # --------------------------------------------------
    # Combine all funds
    # --------------------------------------------------

    result = (
        pd.concat(
            groups,
            ignore_index=True,
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
    # Return ONLY feature columns.
    #
    # This is important:
    # target_nav_* columns must never reach the
    # feature dataframe.
    # --------------------------------------------------

    return result[
        [
            "isin",
            "nav_date",
            *FEATURE_COLUMNS,
        ]
    ]


def build_prediction_features(
    history: pd.DataFrame,
) -> pd.DataFrame:
    """
    Build features for inference.

    `history` must contain observations available up to
    the forecast origin.

    The final row represents the forecast origin.
    """

    df = build_features(
        history
    )

    if df.empty:
        raise ValueError(
            "Unable to build prediction features: "
            "history produced no feature rows."
        )

    return df[
        FEATURE_COLUMNS
    ]