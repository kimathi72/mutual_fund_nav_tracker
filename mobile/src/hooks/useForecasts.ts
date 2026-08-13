// hooks/useForecasts.ts

import { useQuery } from "@tanstack/react-query";

import {
  fetchForecastHistory,
  fetchForecastReport,
  fetchLatestForecasts,
} from "@/api/forecast";

import type {
  Forecast,
  ForecastReport,
} from "@/models/Forecast";

/**
 * Latest forecasts across the portfolio.
 */
export function useLatestForecasts() {
  return useQuery<Forecast[]>({
    queryKey: ["forecasts", "latest"],

    queryFn: fetchLatestForecasts,

    staleTime: 5 * 60 * 1000,

    gcTime: 15 * 60 * 1000,

    refetchOnWindowFocus: false,

    retry: 2,
  });
}

/**
 * Forecast history for one fund.
 */
export function useForecastHistory(
  isin: string,
) {
  return useQuery<Forecast[]>({
    queryKey: ["forecasts", "history", isin],

    queryFn: () => fetchForecastHistory(isin),

    enabled: Boolean(isin),

    staleTime: 5 * 60 * 1000,

    gcTime: 15 * 60 * 1000,

    refetchOnWindowFocus: false,

    retry: 2,
  });
}

/**
 * Complete forecast report.
 *
 * IMPORTANT:
 * The query function is wrapped in an arrow function
 * rather than passing a function expecting `isin`
 * directly to React Query.
 */
export function useForecastReport(
  isin?: string,
) {
  return useQuery<ForecastReport>({
    queryKey: ["forecasts", "report", isin ?? "portfolio"],

    queryFn: () => fetchForecastReport(isin),

    enabled: isin === undefined || Boolean(isin),

    staleTime: 5 * 60 * 1000,

    gcTime: 15 * 60 * 1000,

    refetchOnWindowFocus: false,

    retry: 2,
  });
}