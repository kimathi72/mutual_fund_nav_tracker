from __future__ import annotations

from abc import ABC

import pandas as pd

from app.data.feature_builder import build_features
from app.data.target_builder import TargetBuilder


class ForecastHorizon(ABC):

    NAME = ""
    TARGET_DAYS = 1

    def build_training_frame(
        self,
        dataframe: pd.DataFrame,
    ) -> pd.DataFrame:

        features = build_features(dataframe)

        dataset = TargetBuilder(
            dataframe=features,
            horizon=self.NAME,
        ).build()

        return dataset

    @property
    def model_directory(self):

        return f"models/{self.NAME}"