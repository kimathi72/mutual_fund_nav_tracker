from __future__ import annotations

from dataclasses import asdict
from dataclasses import dataclass
from datetime import datetime

import numpy as np

from sklearn.metrics import (
    mean_absolute_error,
    mean_squared_error,
    r2_score,
)


@dataclass
class EvaluationResult:

    horizon: str

    model_version: str

    trained_at: str

    sample_count: int

    rmse: float

    mae: float

    mape: float

    r2: float

    prediction_interval_coverage: float

    average_interval_width: float

    confidence_score: float

    def to_dict(self):

        return asdict(self)


class Evaluator:

    def __init__(
        self,
        model_version: str = "xgboost-q-v2",
    ):

        self.model_version = model_version

    # ---------------------------------------------------------

    def evaluate(
        self,
        *,
        horizon: str,
        actual,
        median_prediction,
        lower_prediction,
        upper_prediction,
    ) -> EvaluationResult:

        actual = np.asarray(actual)

        median_prediction = np.asarray(
            median_prediction
        )

        lower_prediction = np.asarray(
            lower_prediction
        )

        upper_prediction = np.asarray(
            upper_prediction
        )

        rmse = np.sqrt(
            mean_squared_error(
                actual,
                median_prediction,
            )
        )

        mae = mean_absolute_error(
            actual,
            median_prediction,
        )

        mape = self.compute_mape(
            actual,
            median_prediction,
        )

        r2 = r2_score(
            actual,
            median_prediction,
        )

        coverage = self.compute_picp(
            actual,
            lower_prediction,
            upper_prediction,
        )

        width = self.compute_interval_width(
            lower_prediction,
            upper_prediction,
        )

        confidence = self.compute_confidence(
            width,
            median_prediction,
        )

        return EvaluationResult(

            horizon=horizon,

            model_version=self.model_version,

            trained_at=datetime.utcnow().isoformat(),

            sample_count=len(actual),

            rmse=float(rmse),

            mae=float(mae),

            mape=float(mape),

            r2=float(r2),

            prediction_interval_coverage=float(
                coverage
            ),

            average_interval_width=float(
                width
            ),

            confidence_score=float(
                confidence
            ),
        )

    # ---------------------------------------------------------

    @staticmethod
    def average(
        results: list[EvaluationResult],
    ) -> EvaluationResult:

        if not results:
            raise ValueError(
                "No evaluation results supplied."
            )

        first = results[0]

        return EvaluationResult(

            horizon=first.horizon,

            model_version=first.model_version,

            trained_at=datetime.utcnow().isoformat(),

            sample_count=int(
                np.mean(
                    [
                        r.sample_count
                        for r in results
                    ]
                )
            ),

            rmse=float(
                np.mean(
                    [
                        r.rmse
                        for r in results
                    ]
                )
            ),

            mae=float(
                np.mean(
                    [
                        r.mae
                        for r in results
                    ]
                )
            ),

            mape=float(
                np.mean(
                    [
                        r.mape
                        for r in results
                    ]
                )
            ),

            r2=float(
                np.mean(
                    [
                        r.r2
                        for r in results
                    ]
                )
            ),

            prediction_interval_coverage=float(
                np.mean(
                    [
                        r.prediction_interval_coverage
                        for r in results
                    ]
                )
            ),

            average_interval_width=float(
                np.mean(
                    [
                        r.average_interval_width
                        for r in results
                    ]
                )
            ),

            confidence_score=float(
                np.mean(
                    [
                        r.confidence_score
                        for r in results
                    ]
                )
            ),
        )

    # ---------------------------------------------------------

    @staticmethod
    def compute_mape(
        actual,
        prediction,
    ):

        denominator = np.maximum(
            np.abs(actual),
            1e-9,
        )

        return np.mean(
            np.abs(
                actual - prediction
            )
            / denominator
        ) * 100

    # ---------------------------------------------------------

    @staticmethod
    def compute_picp(
        actual,
        lower,
        upper,
    ):

        inside = (
            (actual >= lower)
            &
            (actual <= upper)
        )

        return float(
            np.mean(
                inside
            )
        )

    # ---------------------------------------------------------

    @staticmethod
    def compute_interval_width(
        lower,
        upper,
    ):

        return float(
            np.mean(
                upper - lower
            )
        )

    # ---------------------------------------------------------

    @staticmethod
    def compute_confidence(
        interval_width,
        prediction,
    ):

        average_prediction = np.mean(
            np.abs(
                prediction
            )
        )

        if average_prediction == 0:

            return 0.0

        relative_width = (
            interval_width
            / average_prediction
        )

        confidence = max(
            0.0,
            min(
                1.0,
                1 - relative_width,
            ),
        )

        return float(
            confidence
        )