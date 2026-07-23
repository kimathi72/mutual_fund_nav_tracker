import { useQuery } from "@tanstack/react-query";

import {
  fetchForecastHistory,
  fetchLatestForecasts,
} from "@/api/forecast";

import type {
  Forecast,
} from "@/models/Forecast";

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

export function useForecastHistory(isin: string) {
  return useQuery<Forecast[]>({
    queryKey: ["forecasts", isin],

    queryFn: () => fetchForecastHistory(isin),

    enabled: !!isin,

    staleTime: 5 * 60 * 1000,
    gcTime: 15 * 60 * 1000,

    refetchOnWindowFocus: false,
    retry: 2,
  });
}