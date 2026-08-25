import React, { useMemo } from "react";
import { Polyline } from "react-native-svg";

import { RendererProps } from "../types";

import { toChartPoints } from "../utils/chartMath";

import ExecutiveChartTheme from "../ExecutiveChartTheme";

export default function SparklineRenderer({
  data,
  width,
  height,
  color = ExecutiveChartTheme.colors.historical,
  strokeWidth = 2,
}: RendererProps) {
  const points = useMemo(
    () =>
      toChartPoints(
        data,
        width,
        height
      ),
    [data, width, height]
  );

  if (points.length < 2) {
    return null;
  }

  return (
    <Polyline
      points={points
        .map(point => `${point.x},${point.y}`)
        .join(" ")}
      fill="none"
      stroke={color}
      strokeWidth={strokeWidth}
    />
  );
}