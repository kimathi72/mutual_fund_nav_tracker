import React from "react";

import ChartSurface from "./ChartSurface";

import { LineRenderer } from "./renderers";

import ExecutiveChartTheme from "./ExecutiveChartTheme";

import { TimeSeriesPoint } from "./types";

type Props = {
  data: TimeSeriesPoint[];

  width?: number;

  height?: number;
};

export default function SparkLine({
  data,
  width = 120,
  height = 50,
}: Props) {
  if (data.length < 2) {
    return null;
  }

  return (
    <ChartSurface
      width={width}
      height={height}
    >
      <LineRenderer
        data={data}
        width={width}
        height={height}
        color={ExecutiveChartTheme.line}
        strokeWidth={2}
      />
    </ChartSurface>
  );
}