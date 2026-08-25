from __future__ import annotations

import os

from pathlib import Path

import pandas as pd


DEFAULT_DATASET = Path(
    os.getenv(
        "DATASET_PATH",
        "/app/exports/mutual_funds_dataset.csv",
    )
)


def resolve_dataset():

    candidates = [

        DEFAULT_DATASET,

        Path("/app/exports/mutual_funds_dataset.csv"),

        Path("/app/exports/training_dataset.csv"),

        Path("exports/mutual_funds_dataset.csv"),

    ]


    for path in candidates:

        if path.exists():

            return path


    raise FileNotFoundError(
        f"""
No dataset found.

Checked:

{candidates}

Current directory:

{Path.cwd()}

Exports:

{list(Path('/app/exports').glob('*')) 
 if Path('/app/exports').exists()
 else 'missing'}
"""
    )


def load_dataset(
    dataset_path=None,
):

    if dataset_path is None:

        dataset_path = resolve_dataset()


    dataset_path = Path(dataset_path)


    dataframe = pd.read_csv(
        dataset_path
    )


    dataframe.columns = (
        dataframe.columns
        .str.strip()
        .str.lower()
    )


    required = {
        "isin",
        "nav_date",
        "nav",
    }


    missing = (
        required
        -
        set(dataframe.columns)
    )


    if missing:

        raise ValueError(
            f"Missing columns {missing}"
        )


    dataframe["nav_date"] = pd.to_datetime(
        dataframe["nav_date"],
        errors="coerce",
    )


    dataframe["nav"] = pd.to_numeric(
        dataframe["nav"],
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


    return dataframe.reset_index(
        drop=True
    )



def load_single_fund(
    dataframe,
    isin,
):

    result = dataframe[
        dataframe["isin"] == isin
    ]


    if result.empty:

        raise ValueError(
            f"No NAV history found for {isin}"
        )


    return result.copy()



def latest_history(
    dataframe,
    lookback=365,
):

    return dataframe.tail(
        lookback
    ).copy()