from pydantic import BaseModel


class PredictionRequest(BaseModel):
    nav: float
    daily_return: float
    weekly_return: float
    monthly_return: float
    ytd_return: float
    moving_average_7: float
    moving_average_30: float
    volatility_30: float
    drawdown: float