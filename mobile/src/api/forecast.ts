// api/forecast.ts

import api from "./client";

import type {
  Forecast,
  ForecastReport,
} from "@/models/Forecast";

interface ApiResponse<T> {
  success: boolean;
  generated_at: string;
  api_version: string;
  data: T;
}

/**
 * Fetch the latest forecast set.
 *
 * This is useful for dashboard-level forecast summaries.
 */
export async function fetchLatestForecasts(): Promise<Forecast[]> {
  const { data } = await api.get<ApiResponse<Forecast[]>>(
    "/forecasts/latest",
  );

  return data.data;
}

/**
 * Fetch forecast history for a specific fund.
 */
export async function fetchForecastHistory(
  isin: string,
): Promise<Forecast[]> {
  const { data } = await api.get<ApiResponse<Forecast[]>>(
    `/forecasts/${encodeURIComponent(isin)}`,
  );

  return data.data;
}

/**
 * Fetch the forecast report for a specific fund.
 *
 * The backend contract is:
 *
 * GET /forecasts
 * GET /forecasts/:isin
 *
 * If the backend's /forecasts endpoint is currently global,
 * this function can still be used without an ISIN.
 */
export async function fetchForecastReport(
  isin?: string,
): Promise<ForecastReport> {
  const endpoint = isin
    ? `/forecasts?isin=${encodeURIComponent(isin)}`
    : "/forecasts";

  const { data } = await api.get<ApiResponse<ForecastReport>>(
    endpoint,
  );

  return data.data;
}