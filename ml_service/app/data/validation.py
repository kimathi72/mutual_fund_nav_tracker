from __future__ import annotations

import pandas as pd


REQUIRED_COLUMNS = [
    "isin",
    "nav_date",
    "nav",
]


def validate_dataset(
    dataframe: pd.DataFrame,
) -> pd.DataFrame:
    """
    Validate the historical NAV dataset before
    feature engineering and training.
    """

    if dataframe is None:
        raise ValueError(
            "Dataset is None."
        )

    if dataframe.empty:
        raise ValueError(
            "Dataset is empty."
        )

    missing = [
        column
        for column in REQUIRED_COLUMNS
        if column not in dataframe.columns
    ]

    if missing:
        raise ValueError(
            f"Missing required columns: {missing}"
        )

    dataframe = dataframe.copy()

    dataframe["nav"] = pd.to_numeric(
        dataframe["nav"],
        errors="coerce",
    )

    dataframe["nav_date"] = pd.to_datetime(
        dataframe["nav_date"],
        errors="coerce",
    )

    dataframe = dataframe.dropna(
        subset=[
            "isin",
            "nav_date",
            "nav",
        ]
    )

    dataframe = dataframe.sort_values(
        [
            "isin",
            "nav_date",
        ]
    )

    dataframe = dataframe.reset_index(
        drop=True
    )

    return dataframe


# Backwards compatibility
validate_dataframe = validate_dataset