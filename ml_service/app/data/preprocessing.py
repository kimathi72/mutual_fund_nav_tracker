from __future__ import annotations

import numpy as np
import pandas as pd


def preprocess(
    dataframe: pd.DataFrame,
) -> pd.DataFrame:
    """
    Cleans historical NAV data before feature engineering.

    Pipeline
    --------
    1. Sort records
    2. Remove duplicate dates
    3. Fill small gaps
    4. Remove impossible values
    5. Clip extreme outliers
    """

    dataframe = dataframe.copy()

    dataframe = sort_data(dataframe)

    dataframe = remove_duplicates(dataframe)

    dataframe = fill_missing_values(dataframe)

    dataframe = remove_invalid_rows(dataframe)

    dataframe = clip_outliers(dataframe)

    dataframe.reset_index(
        drop=True,
        inplace=True,
    )

    return dataframe


# ---------------------------------------------------------
# Sorting
# ---------------------------------------------------------

def sort_data(
    dataframe: pd.DataFrame,
) -> pd.DataFrame:

    return dataframe.sort_values(
        [
            "isin",
            "nav_date",
        ]
    )


# ---------------------------------------------------------
# Duplicate removal
# ---------------------------------------------------------

def remove_duplicates(
    dataframe: pd.DataFrame,
) -> pd.DataFrame:

    return dataframe.drop_duplicates(
        subset=[
            "isin",
            "nav_date",
        ]
    )


# ---------------------------------------------------------
# Missing values
# ---------------------------------------------------------

def fill_missing_values(
    dataframe: pd.DataFrame,
) -> pd.DataFrame:

    dataframe["nav"] = (
        dataframe
        .groupby("isin")["nav"]
        .ffill()
        .bfill()
    )

    return dataframe


# ---------------------------------------------------------
# Remove impossible values
# ---------------------------------------------------------

def remove_invalid_rows(
    dataframe: pd.DataFrame,
) -> pd.DataFrame:

    dataframe = dataframe.loc[
        dataframe["nav"] > 0
    ]

    dataframe = dataframe.dropna(
        subset=[
            "nav",
            "nav_date",
            "isin",
        ]
    )

    return dataframe


# ---------------------------------------------------------
# Outlier clipping
# ---------------------------------------------------------

def clip_outliers(
    dataframe: pd.DataFrame,
    lower_quantile: float = 0.01,
    upper_quantile: float = 0.99,
) -> pd.DataFrame:

    def clip(group: pd.DataFrame):

        low = group["nav"].quantile(
            lower_quantile
        )

        high = group["nav"].quantile(
            upper_quantile
        )

        group["nav"] = np.clip(
            group["nav"],
            low,
            high,
        )

        return group

    dataframe = (
        dataframe
        .groupby(
            "isin",
            group_keys=False,
        )
        .apply(clip)
    )

    return dataframe