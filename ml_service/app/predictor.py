import joblib
import pandas as pd

from .config import MODEL_PATH
from .trainer import ModelTrainer


class Predictor:

    def __init__(self):
        self.model = joblib.load(MODEL_PATH)

    def predict(self, payload):
        frame = pd.DataFrame([payload])

        prediction = self.model.predict(
            frame[ModelTrainer.FEATURES]
        )[0]

        return float(prediction)