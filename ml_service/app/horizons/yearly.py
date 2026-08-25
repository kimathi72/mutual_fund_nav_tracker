from app.horizons.base import ForecastHorizon


class YearlyForecast(ForecastHorizon):

    NAME = "365d"

    TARGET_DAYS = 365