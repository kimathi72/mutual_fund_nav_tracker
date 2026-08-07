import React, { useMemo } from "react";

import { Polyline } from "react-native-svg";

import { RendererProps } from "../types";

import { toChartPoints } from "../utils/chartMath";
import { getChartDimensions } from "../utils/chartDimensions";

import ExecutiveChartTheme from "../ExecutiveChartTheme";

export default function LineRenderer({
  data,

  width,

  height,

  color = ExecutiveChartTheme.colors.historical,

  strokeWidth = ExecutiveChartTheme.chart.strokeWidth,

  dashed = false,
}: RendererProps) {
  const chart = getChartDimensions(width, height);

  const points = useMemo(
    () =>
      toChartPoints(
        data,

        chart.innerWidth,

        chart.innerHeight,
      ).map((point) => ({
        x: point.x + chart.paddingLeft,

        y: point.y + chart.paddingTop,
      })),

    [data, chart],
  );

  if (points.length < 2) {
    return null;
  }

  return (
    <Polyline
      points={points

        .map((point) => `${point.x},${point.y}`)

        .join(" ")}
      fill="none"
      stroke={color}
      strokeWidth={strokeWidth}
      strokeDasharray={dashed ? "8 6" : undefined}
    />
  );
}
