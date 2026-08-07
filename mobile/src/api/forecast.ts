import api from "./client";

import type { Forecast, ForecastReport } from "@/models/Forecast";

interface ApiResponse<T> {
  success: boolean;
  generated_at: string;
  api_version: string;
  data: T;
}

export async function fetchLatestForecasts(): Promise<Forecast[]> {
  const { data } = await api.get<ApiResponse<Forecast[]>>(
    "/forecasts/latest"
  );

  return data.data;
}

export async function fetchForecastHistory(isin: string): Promise<Forecast[]> {
  const { data } = await api.get<ApiResponse<Forecast[]>>(
    `/forecasts/${isin}`
  );

  return data.data;
}

export async function fetchForecastReport(): Promise<ForecastReport> {
  const { data } = await api.get<ApiResponse<ForecastReport>>(
    "/forecasts"
  );

  return data.data;
}
