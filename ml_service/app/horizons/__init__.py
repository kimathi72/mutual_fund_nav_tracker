from app.horizons.daily import DailyForecast
from app.horizons.monthly import MonthlyForecast
from app.horizons.quarterly import QuarterlyForecast



HORIZONS = [
    DailyForecast(),
    MonthlyForecast(),
    QuarterlyForecast()
    
]

