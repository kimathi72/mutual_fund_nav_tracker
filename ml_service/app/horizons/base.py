from __future__ import annotations


class ForecastHorizon:
    """
    Defines one forecasting horizon.

    TARGET_OBSERVATIONS represents the number of
    future NAV observations, NOT calendar days.
    """

    NAME: str
    TARGET_OBSERVATIONS: int