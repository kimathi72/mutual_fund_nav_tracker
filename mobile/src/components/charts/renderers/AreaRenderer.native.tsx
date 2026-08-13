// components/charts/renderers/AreaRenderer.native.tsx

import React, { useMemo } from "react";

import {
  Path,
} from "@shopify/react-native-skia";

import type {
  AreaRendererProps,
} from "../types";

import {
  toChartPoints,
} from "../utils/chartMath";

import {
  buildAreaPath,
} from "../utils/chartArea.native";

import {
  buildLinePath,
} from "../utils/chartPath";

import ExecutiveChartTheme
  from "../ExecutiveChartTheme";

export default function AreaRenderer({
  data,
  width,
  height,
  color =
    ExecutiveChartTheme.colors.historical,
  fillColor =
    ExecutiveChartTheme.colors.surface,
}: AreaRendererProps) {
  const points = useMemo(
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

  const line = useMemo(
    () =>
      buildLinePath(
        points,
      ),
    [points],
  );

  const area = useMemo(
    () =>
      buildAreaPath(
        points,
        height,
      ),
    [
      points,
      height,
    ],
  );

  if (
    points.length < 2
  ) {
    return null;
  }

  return (
    <>
      {/* Filled area */}
      <Path
        path={area}
        color={fillColor}
      />

      {/* Volatility line */}
      <Path
        path={line}
        color={color}
        style="stroke"
        strokeWidth={
          ExecutiveChartTheme.chart
            .strokeWidth
        }
        strokeCap="round"
        strokeJoin="round"
      />
    </>
  );
}