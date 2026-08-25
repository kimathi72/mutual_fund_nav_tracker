from __future__ import annotations

import json

from pathlib import Path
from dataclasses import asdict


ARTIFACT_ROOT = Path("artifacts")

METRICS_DIR = ARTIFACT_ROOT / "metrics"

REPORT_DIR = METRICS_DIR / "reports"

LOG_DIR = ARTIFACT_ROOT / "logs"


for directory in (
    METRICS_DIR,
    REPORT_DIR,
    LOG_DIR,
):
    directory.mkdir(
        parents=True,
        exist_ok=True,
    )


# ------------------------------------------------------
# Metrics
# ------------------------------------------------------

def save_metrics(result):

    filepath = (
        METRICS_DIR
        / f"{result.horizon}_metrics.json"
    )

    with open(
        filepath,
        "w",
        encoding="utf-8",
    ) as file:

        json.dump(
            asdict(result),
            file,
            indent=4,
        )


def load_metrics(
    horizon: str,
):

    filepath = (
        METRICS_DIR
        / f"{horizon}_metrics.json"
    )

    if not filepath.exists():
        return None

    with open(
        filepath,
        "r",
        encoding="utf-8",
    ) as file:

        return json.load(file)


# ------------------------------------------------------
# Reports
# ------------------------------------------------------

def save_training_summary(
    summary: list,
):

    filepath = (
        REPORT_DIR
        / "training_summary.json"
    )

    with open(
        filepath,
        "w",
        encoding="utf-8",
    ) as file:

        json.dump(
            summary,
            file,
            indent=4,
        )


def save_latest_training(
    summary: list,
):

    filepath = (
        REPORT_DIR
        / "latest_training.json"
    )

    with open(
        filepath,
        "w",
        encoding="utf-8",
    ) as file:

        json.dump(
            summary,
            file,
            indent=4,
        )


def load_training_summary():

    filepath = (
        REPORT_DIR
        / "training_summary.json"
    )

    if not filepath.exists():
        return None

    with open(
        filepath,
        "r",
        encoding="utf-8",
    ) as file:

        return json.load(file)