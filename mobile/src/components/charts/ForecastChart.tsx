import React from "react";

import ChartSurface from "./ChartSurface";

import { LineRenderer } from "./renderers";

import ExecutiveChartTheme from "./ExecutiveChartTheme";

import { TimeSeriesPoint } from "./types";

type Props = {
  history: TimeSeriesPoint[];

  forecast: TimeSeriesPoint[];

  width?: number;

  height?: number;
};

export default function ForecastChart({
  history,
  forecast,
  width = 340,
  height = 180,
}: Props) {
  if (history.length < 2) {
    return null;
  }

  const forecastData =
    forecast.length > 0
      ? [
          history[history.length - 1],
          ...forecast,
        ]
      : [];

  return (
    <ChartSurface
      width={width}
      height={height}
    >
      <LineRenderer
        data={history}
        width={width}
        height={height}
        color={ExecutiveChartTheme.historical}
      />

      {forecastData.length > 1 && (
        <LineRenderer
          data={forecastData}
          width={width}
          height={height}
          color={ExecutiveChartTheme.forecast}
          dashed
        />
      )}
    </ChartSurface>
  );
}