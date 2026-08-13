import React, {
  useMemo,
} from "react";

import {
  DashPathEffect,
  Path,
} from "@shopify/react-native-skia";

import type {
  RendererProps,
} from "../types";

import {
  toChartPoints,
} from "../utils/chartMath";

import {
  buildLinePath,
} from "../utils/chartPath";

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

  const path =
    buildLinePath(points);

  return (
    <Path
      path={path}
      color={color}
      style="stroke"
      strokeWidth={strokeWidth}
      strokeCap="round"
      strokeJoin="round"
    >
      {dashed && (
        <DashPathEffect
          intervals={[8, 6]}
          phase={0}
        />
      )}
    </Path>
  );
}