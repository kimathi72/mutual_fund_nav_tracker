from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

DATA_DIR = BASE_DIR / "exports"

MODEL_DIR = BASE_DIR / "models"

ARTIFACT_DIR = BASE_DIR / "artifacts"

HORIZONS = {
    "1d": 1,
    "30d": 30,
    "90d": 90,
    "365d": 365,
}

QUANTILES = {
    "lower": 0.10,
    "median": 0.50,
    "upper": 0.90,
}

RANDOM_STATE = 42

TEST_SIZE = 0.20

FEATURE_COLUMNS = [
    "nav",
    "return_1d",
    "return_7d",
    "return_30d",
    "ma_7",
    "ma_30",
    "ma_90",
    "volatility_30",
    "momentum",
]

TARGET_COLUMN = "future_nav"