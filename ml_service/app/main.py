from fastapi import FastAPI

from .predictor import Predictor
from .schemas import PredictionRequest
from .trainer import ModelTrainer

app = FastAPI()


@app.get("/")
def root():
    return {
        "service": "Mutual Fund ML Service",
        "status": "running"
    }


@app.post("/train")
def train():
    result = ModelTrainer().train()

    return {
        "status": "success",
        **result
    }


@app.post("/predict")
def predict(request: PredictionRequest):
    prediction = Predictor().predict(
        request.model_dump()
    )

    return {
        "prediction": prediction
    }