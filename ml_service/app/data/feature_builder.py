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


def build_features(dataframe: pd.DataFrame) -> pd.DataFrame:
    """
    Build ML features independently for each fund.

    Every rolling statistic, return and momentum calculation
    is isolated per ISIN.
    """

    df = dataframe.copy()

    if "date" in df.columns and "nav_date" not in df.columns:
        df = df.rename(columns={"date": "nav_date"})

    df["nav_date"] = pd.to_datetime(df["nav_date"])

    df = df.sort_values(
        ["isin", "nav_date"]
    ).reset_index(drop=True)

    groups = []

    for isin, fund in df.groupby("isin", sort=False):

        fund = fund.copy()

        fund["return_1d"] = fund["nav"].pct_change(1)

        fund["return_7d"] = fund["nav"].pct_change(7)

        fund["return_30d"] = fund["nav"].pct_change(30)

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

        fund = fund.dropna()

        groups.append(fund)

    result = (
        pd.concat(groups, ignore_index=True)
        .sort_values(["isin", "nav_date"])
        .reset_index(drop=True)
    )

    return result


def build_prediction_features(history: pd.DataFrame) -> pd.DataFrame:
    """
    Builds inference features for a single fund.

    Predictor passes one ISIN at a time.
    """

    df = history.copy()

    if "date" in df.columns:
        df = df.rename(columns={"date": "nav_date"})

    df["nav_date"] = pd.to_datetime(df["nav_date"])

    df = build_features(df)

    return df[FEATURE_COLUMNS]