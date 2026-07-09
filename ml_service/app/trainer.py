import joblib
from pathlib import Path

from xgboost import XGBRegressor

from .config import MODEL_PATH
from .dataset import DatasetLoader


class ModelTrainer:

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

    TARGET = "next_day_nav"

    def train(self):
        df = DatasetLoader().load()

        df = df.dropna()

        X = df[self.FEATURES]
        y = df[self.TARGET]

        model = XGBRegressor(
            n_estimators=300,
            max_depth=6,
            learning_rate=0.05,
            objective="reg:squarederror",
            random_state=42
        )

        model.fit(X, y)

        Path(MODEL_PATH).parent.mkdir(
            parents=True,
            exist_ok=True
        )

        joblib.dump(model, MODEL_PATH)

        return {
            "status": "success",
            "rows": len(df),
            "features": len(self.FEATURES),
            "target": self.TARGET,
            "model_path": str(MODEL_PATH)
        }