from app.horizons.base import ForecastHorizon


class QuarterlyForecast(ForecastHorizon):

    NAME = "90d"

    TARGET_DAYS = 90