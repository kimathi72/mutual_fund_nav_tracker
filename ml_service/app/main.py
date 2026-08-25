from __future__ import annotations

from fastapi import FastAPI

from app.api.routes import router

app = FastAPI(
    title="Mutual Fund Forecast Service",
    version="2.0.0",
)

app.include_router(router)


@app.get("/")
def root():
    return {
        "service": "Mutual Fund Forecast Service",
        "status": "healthy",
        "version": "2.0.0",
    }