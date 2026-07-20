import pandas as pd

from app.config import TARGET_COLUMN

HORIZON_DAYS = {
    "1d": 1,
    "30d": 30,
    "90d": 90,
    "365d": 365,
}


class TargetBuilder:

    def __init__(
        self,
        dataframe: pd.DataFrame,
        horizon: str,
    ):
        self.df = dataframe.copy()
        self.horizon = horizon

    def build(self):

        shift = HORIZON_DAYS[self.horizon]

        self.df[TARGET_COLUMN] = (
            self.df
                .groupby("isin")["nav"]
                .shift(-shift)
        )

        self.df.dropna(
            subset=[TARGET_COLUMN],
            inplace=True,
        )

        self.df.reset_index(
            drop=True,
            inplace=True,
        )

        return self.df