import joblib
import pandas as pd

from .config import MODEL_PATH


class Predictor:

    FEATURES = [
        "nav",
        "daily_return",
        "weekly_return",
        "monthly_return",
        "ytd_return",
        "moving_average_7",
        "moving_average_30",
        "volatility_30",
        "drawdown"
    ]

    def __init__(self):
        self.model = joblib.load(MODEL_PATH)

    def predict(self, payload):
        frame = pd.DataFrame([payload])

        prediction = self.model.predict(
            frame[self.FEATURES]
        )[0]

        return float(prediction)