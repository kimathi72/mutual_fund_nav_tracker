import React, { useMemo, useState } from "react";

import ChartContainer from "./ChartContainer";

import { LineRenderer } from "./renderers";

import ExecutiveChartTheme from "./ExecutiveChartTheme";

import {
  ChartRange,
  TimeSeriesPoint,
} from "./types";

import { filterChartData } from "./utils/chartFilters";

type Props = {
  history: TimeSeriesPoint[];
  forecast: TimeSeriesPoint[];
};

export default function ForecastChart({
  history,
  forecast,
}: Props) {
  const [range, setRange] =
    useState<ChartRange>("1M");

  /**
   * Filter historical data
   */
  const filteredHistory = useMemo(
    () => filterChartData(history, range),
    [history, range]
  );

  /**
   * Filter forecast using the same range.
   * This keeps both charts synchronized.
   */
  const filteredForecast = useMemo(
    () => filterChartData(forecast, range),
    [forecast, range]
  );

  /**
   * Join the last visible history point to the
   * first visible forecast point so the dashed
   * prediction begins exactly where history ends.
   */
  const forecastSeries = useMemo(() => {
    if (
      filteredHistory.length === 0 ||
      filteredForecast.length === 0
    ) {
      return [];
    }

    return [
      filteredHistory[
        filteredHistory.length - 1
      ],
      ...filteredForecast,
    ];
  }, [
    filteredHistory,
    filteredForecast,
  ]);

  if (filteredHistory.length < 2) {
    return null;
  }

  return (
    <ChartContainer
      title="Forecast"
      subtitle="Historical vs Predicted NAV"
      data={filteredHistory}
      range={range}
      onRangeChange={setRange}
    >
      {({ width, height }) => (
        <>
          {/* Historical */}
          <LineRenderer
            data={filteredHistory}
            width={width}
            height={height}
            color={
              ExecutiveChartTheme.colors
                .historical
            }
          />

          {/* Forecast */}
          {forecastSeries.length > 1 && (
            <LineRenderer
              data={forecastSeries}
              width={width}
              height={height}
              color={
                ExecutiveChartTheme.colors
                  .forecast
              }
              dashed
            />
          )}
        </>
      )}
    </ChartContainer>
  );
}