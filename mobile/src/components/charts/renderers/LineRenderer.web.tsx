import React, {
  useMemo,
} from "react";

import {
  Polyline,
} from "react-native-svg";

import type {
  RendererProps,
} from "../types";

import {
  toChartPoints,
} from "../utils/chartMath";

import ExecutiveChartTheme
  from "../ExecutiveChartTheme";

export default function LineRenderer({
  data,
  width,
  height,
  color =
    ExecutiveChartTheme.colors
      .historical,
  strokeWidth =
    ExecutiveChartTheme.chart
      .strokeWidth,
  dashed = false,
}: RendererProps) {
  const points =
    useMemo(
      () =>
        toChartPoints(
          data,
          width,
          height,
        ),
      [
        data,
        width,
        height,
      ],
    );

  if (
    points.length < 2
  ) {
    return null;
  }

  const pointString =
    points
      .map(
        (point) =>
          `${point.x},${point.y}`,
      )
      .join(" ");

  return (
    <Polyline
      points={pointString}
      fill="none"
      stroke={color}
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      strokeDasharray={
        dashed
          ? "8 6"
          : undefined
      }
    />
  );
}