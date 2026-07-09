from fastapi import FastAPI

from .trainer import ModelTrainer
from .predictor import Predictor

app = FastAPI(
    title="Forecast Engine",
    version="1.0"
)


@app.get("/")
def root():
    return {
        "status": "healthy"
    }


@app.post("/train")
def train():
    return ModelTrainer().train()


@app.post("/predict")
def predict(payload: dict):
    prediction = Predictor().predict(payload)

    return {
        "prediction": prediction,
        "confidence": 0.95
    }