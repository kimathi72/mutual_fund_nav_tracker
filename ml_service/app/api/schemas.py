from __future__ import annotations

from datetime import datetime, date

from typing import List, Optional

from pydantic import BaseModel, Field


# ==========================================================
# Historical NAV Point
# ==========================================================

class NavPoint(BaseModel):

    date: date

    nav: float



# ==========================================================
# Single Fund Forecast Request
# ==========================================================

class ForecastRequest(BaseModel):

    isin: str

    history: List[NavPoint]

    generated_at: datetime = Field(
        default_factory=datetime.utcnow
    )



# ==========================================================
# Portfolio Forecast Request
# ==========================================================

class PortfolioForecastRequest(BaseModel):

    funds: List[ForecastRequest]



# ==========================================================
# Backward compatibility
# ==========================================================

# Existing routes.py may use BatchForecastRequest
# Keep both names working.

BatchForecastRequest = PortfolioForecastRequest



# ==========================================================
# Horizon Prediction
# ==========================================================

class HorizonPrediction(BaseModel):

    horizon: str

    target_days: int

    target_date: date

    predicted_nav: float

    expected_return_pct: float

    lower_bound: float

    upper_bound: float

    confidence_score: float

    interval_width: float

    model_version: str

    rmse: Optional[float] = None

    mae: Optional[float] = None

    sample_count: Optional[int] = None



# ==========================================================
# Single Forecast Response
# ==========================================================

class ForecastResponse(BaseModel):

    isin: str

    generated_at: datetime

    predictions: List[HorizonPrediction]


# ==========================================================
# Batch Forecast Request
# ==========================================================

class BatchForecastRequest(BaseModel):

    funds: List[ForecastRequest]
# ==========================================================
# Portfolio Forecast Response
# ==========================================================

class BatchForecastResponse(BaseModel):

    forecasts: List[ForecastResponse]



# ==========================================================
# Training Response
# ==========================================================

class TrainResponse(BaseModel):

    success: bool

    message: str



# ==========================================================
# Health Response
# ==========================================================

class HealthResponse(BaseModel):

    status: str

    service: str

    version: str