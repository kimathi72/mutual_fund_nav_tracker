from __future__ import annotations

from pathlib import Path

import joblib


class ModelRegistry:
    """
    Lazily loads trained models and caches them.

    models/
        1d/
            lower.pkl
            median.pkl
            upper.pkl

        30d/
            lower.pkl
            median.pkl
            upper.pkl

        90d/
            lower.pkl
            median.pkl
            upper.pkl

        365d/
            lower.pkl
            median.pkl
            upper.pkl
    """

    def __init__(self, models_dir: str = "models"):
        self.models_dir = Path(models_dir)
        self.cache: dict[str, dict[str, object]] = {}

    # ---------------------------------------------------------

    def load_horizon(self, horizon: str):
        """
        Load all quantile models for one horizon.

        Example:
            registry.load_horizon("30d")
        """

        if horizon in self.cache:
            return self.cache[horizon]

        folder = self.models_dir / horizon

        if not folder.exists():
            raise FileNotFoundError(
                f"Missing model directory: {folder}"
            )

        models = {
            "lower": joblib.load(folder / "lower.pkl"),
            "median": joblib.load(folder / "median.pkl"),
            "upper": joblib.load(folder / "upper.pkl"),
        }

        self.cache[horizon] = models

        return models

    # ---------------------------------------------------------

    def get_model(
        self,
        horizon: str,
        quantile: str,
    ):
        """
        Retrieve one model.

        Example:

            registry.get_model("30d", "median")
        """

        models = self.load_horizon(horizon)

        if quantile not in models:
            raise KeyError(
                f"{quantile} model missing for {horizon}"
            )

        return models[quantile]

    # ---------------------------------------------------------

    def available_horizons(self):
        """
        Returns folders inside models/.
        """

        return sorted(
            [
                folder.name
                for folder in self.models_dir.iterdir()
                if folder.is_dir()
            ]
        )

    # ---------------------------------------------------------

    def clear(self):
        """
        Clear cache.
        Useful after retraining.
        """

        self.cache.clear()


registry = ModelRegistry()