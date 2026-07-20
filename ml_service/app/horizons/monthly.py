from app.horizons.base import ForecastHorizon


class MonthlyForecast(ForecastHorizon):

    NAME = "30d"

    TARGET_DAYS = 30