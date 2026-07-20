from app.horizons.base import ForecastHorizon


class DailyForecast(ForecastHorizon):

    NAME = "1d"

    TARGET_DAYS = 1