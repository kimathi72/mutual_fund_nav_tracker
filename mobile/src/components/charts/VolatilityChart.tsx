
import React, { useMemo, useState } from "react";

import ChartContainer from "./ChartContainer";
import { AreaRenderer } from "./renderers";

import ExecutiveChartTheme from "./ExecutiveChartTheme";

import {
  ChartRange,
  TimeSeriesPoint,
} from "./types";

import { filterChartData } from "./utils/chartFilters";

import type { VolatilityPoint } from "@/models/VolatilityPoint";

type Props = {
  history: VolatilityPoint[];
};

export default function VolatilityChart({
  history,
}: Props) {
  const [range, setRange] =
    useState<ChartRange>("1M");

  /**
   * Convert the API volatility history into
   * the generic time-series format used by
   * the charting system.
   *
   * VolatilityPoint:
   * {
   *   date: string;
   *   volatility: number;
   * }
   *
   * TimeSeriesPoint:
   * {
   *   date: string;
   *   value: number;
   * }
   */
  const chartHistory = useMemo<TimeSeriesPoint[]>(
    () =>
      (history ?? [])
        .filter((point) => {
          const value = Number(point.volatility);

          return (
            Boolean(point.date) &&
            Number.isFinite(value)
          );
        })
        .map((point) => ({
          date: point.date,
          value: Number(point.volatility),
        })),
    [history],
  );

  const filtered = useMemo(
    () =>
      filterChartData(
        chartHistory,
        range,
      ),
    [chartHistory, range],
  );

  /**
   * A time-series chart needs at least
   * two observations to draw a meaningful
   * line/area.
   */
  if (filtered.length < 2) {
    return null;
  }

  return (
    <ChartContainer
      title="Volatility"
      subtitle={`${filtered.length} observations`}
      data={filtered}
      range={range}
      onRangeChange={setRange}
    >
      {({ width, height }) => (
        <AreaRenderer
          data={filtered}
          width={width}
          height={height}
          color={
            ExecutiveChartTheme.colors
              .volatility
          }
          fillColor="rgba(245,158,11,0.18)"
        />
      )}
    </ChartContainer>
  );
}
