from pathlib import Path
import os

BASE_DIR = Path(__file__).resolve().parent.parent

DATASET_PATH = Path(
    os.getenv(
        "DATASET_PATH",
        BASE_DIR / "exports" / "training_dataset.csv"
    )
)

MODEL_PATH = Path(
    os.getenv(
        "MODEL_PATH",
        BASE_DIR / "exports" / "xgboost_model.pkl"
    )
)