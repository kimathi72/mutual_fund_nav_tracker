import React from "react";

import ChartCard from "./ChartCard";
import ChartSurface from "./ChartSurface";

import { AreaRenderer } from "./renderers";

import ExecutiveChartTheme from "./ExecutiveChartTheme";

import { TimeSeriesPoint } from "./types";

type Props = {
  history: TimeSeriesPoint[];

  width?: number;

  height?: number;
};

export default function VolatilityChart({
  history,
  width = 340,
  height = 180,
}: Props) {
  if (history.length < 2) {
    return null;
  }

  return (
    <ChartCard
      title="Volatility"
      subtitle="30-day rolling volatility"
    >
      <ChartSurface
        width={width}
        height={height}
      >
        <AreaRenderer
          data={history}
          width={width}
          height={height}
          color={ExecutiveChartTheme.volatility}
          fillColor="rgba(245,158,11,0.18)"
        />
      </ChartSurface>
    </ChartCard>
  );
}