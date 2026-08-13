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


def build_features(
    dataframe: pd.DataFrame,
) -> pd.DataFrame:
    """
    Build features independently for each mutual fund.

    All features are calculated using observations available
    at the feature date or earlier.

    Returns are represented as decimal fractions.

    Example:

        1% return  -> 0.01
        -2% return -> -0.02
    """

    df = dataframe.copy()

    if "date" in df.columns and "nav_date" not in df.columns:
        df = df.rename(
            columns={"date": "nav_date"}
        )

    df["nav_date"] = pd.to_datetime(
        df["nav_date"]
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
            ["isin", "nav_date"]
        )
        .reset_index(drop=True)
    )

    groups = []

    for isin, fund in df.groupby(
        "isin",
        sort=False,
    ):

        fund = fund.copy()

        # Decimal fractions, NOT percentages.
        fund["return_1d"] = (
            fund["nav"].pct_change(1)
        )

        fund["return_7d"] = (
            fund["nav"].pct_change(7)
        )

        fund["return_30d"] = (
            fund["nav"].pct_change(30)
        )

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

        fund["volatility_30"] = (
            fund["return_1d"]
            .rolling(30)
            .std()
        )

        fund["momentum"] = (
            fund["nav"]
            - fund["nav"].shift(30)
        )

        groups.append(fund)

    if not groups:
        return pd.DataFrame(
            columns=[
                *df.columns,
                *[
                    column
                    for column in FEATURE_COLUMNS
                    if column not in df.columns
                ],
            ]
        )

    return (
        pd.concat(
            groups,
            ignore_index=True,
        )
        .sort_values(
            ["isin", "nav_date"]
        )
        .reset_index(drop=True)
    )


def build_prediction_features(
    history: pd.DataFrame,
) -> pd.DataFrame:
    """
    Build features for inference.

    `history` must contain observations available up to
    the forecast origin.

    The final row represents the forecast origin.
    """

    df = build_features(history)

    if df.empty:
        raise ValueError(
            "Unable to build prediction features: "
            "history produced no feature rows."
        )

    return df[
        FEATURE_COLUMNS
    ]