import api from "./client";

import { Forecast } from "@/models/Forecast";

export async function fetchLatestForecasts(): Promise<Forecast[]> {
  const { data } =
    await api.get<Forecast[]>(
      "/forecasts/latest"
    );

  return data;
}

export async function fetchForecastHistory(
  isin: string
): Promise<Forecast[]> {
  const { data } =
    await api.get<Forecast[]>(
      `/forecasts/${isin}`
    );

  return data;
}