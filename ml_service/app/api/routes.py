from __future__ import annotations

import pandas as pd

from fastapi import APIRouter
from fastapi import HTTPException

from app.api.schemas import (
    ForecastRequest,
    ForecastResponse,
    PortfolioForecastRequest,
    BatchForecastResponse,
    TrainResponse,
    HealthResponse,
)
from app.services.forecast_service import ForecastService

from app.models.predictor import Predictor
from app.jobs.train_all import main as train_models

router = APIRouter()

predictor = Predictor()


forecast_service = ForecastService()
# ---------------------------------------------------------
# Health
# ---------------------------------------------------------

@router.get(
    "/health",
    response_model=HealthResponse,
)
def health():

    return HealthResponse(
        status="healthy",
        service="forecast-service",
        version="3.0.0",
    )

# ---------------------------------------------------------
# Forecast Entire Portfolio
# ---------------------------------------------------------

@router.post("/forecast")
def forecast():

    try:

        return {
            "forecasts":
                forecast_service.forecast_portfolio()
        }

    except Exception as ex:

        raise HTTPException(
            status_code=500,
            detail=str(ex),
        )
# ---------------------------------------------------------
# Train Models
# ---------------------------------------------------------

@router.post(
    "/train",
    response_model=TrainResponse,
)
def train():

    try:

        train_models()

        return TrainResponse(
            success=True,
            message="Training completed successfully."
        )

    except Exception as ex:

        raise HTTPException(
            status_code=500,
            detail=str(ex)
        )


# ---------------------------------------------------------
# Predict Single Fund
# ---------------------------------------------------------

@router.post(
    "/predict",
    response_model=ForecastResponse,
)
def predict(
    request: ForecastRequest,
):

    try:

        dataframe = pd.DataFrame(
            request.history
        )

        predictions = predictor.predict_all(
            dataframe
        )

        return ForecastResponse(
            isin=request.isin,
            generated_at=request.generated_at,
            predictions=predictions,
        )

    except Exception as ex:

        raise HTTPException(
            status_code=500,
            detail=str(ex),
        )


# ---------------------------------------------------------
# Predict Portfolio
# ---------------------------------------------------------

@router.post(
    "/predict/batch",
    response_model=BatchForecastResponse,
)
def predict_batch(
    request: PortfolioForecastRequest,
):

    forecasts = []

    for fund in request.funds:

        dataframe = pd.DataFrame(
            fund.history
        )

        predictions = predictor.predict_all(
            dataframe
        )

        forecasts.append(
            ForecastResponse(
                isin=fund.isin,
                generated_at=fund.generated_at,
                predictions=predictions,
            )
        )

    return BatchForecastResponse(
        forecasts=forecasts
    )