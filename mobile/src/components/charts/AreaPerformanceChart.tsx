import React from "react";

import ChartCard from "./ChartCard";
import ChartSurface from "./ChartSurface";

import { AreaRenderer } from "./renderers";

import ExecutiveChartTheme from "./ExecutiveChartTheme";

import { TimeSeriesPoint } from "./types";

type Props = {
  data: TimeSeriesPoint[];

  width?: number;

  height?: number;
};

export default function AreaPerformanceChart({
  data,
  width = 340,
  height = 180,
}: Props) {
  if (data.length < 2) {
    return null;
  }

  return (
    <ChartCard
      title="Performance"
      subtitle="Historical trend"
    >
      <ChartSurface
        width={width}
        height={height}
      >
        <AreaRenderer
          data={data}
          width={width}
          height={height}
          color={ExecutiveChartTheme.line}
          fillColor={ExecutiveChartTheme.area}
        />
      </ChartSurface>
    </ChartCard>
  );
}