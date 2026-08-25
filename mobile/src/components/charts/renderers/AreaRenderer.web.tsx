// components/charts/renderers/AreaRenderer.web.tsx

import React, {
  useMemo,
} from "react";

import {
  Path,
} from "react-native-svg";

import type {
  AreaRendererProps,
} from "../types";

import {
  toChartPoints,
} from "../utils/chartMath";

import {
  buildAreaSvgPath,
} from "../utils/chartArea";

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

  const linePath =
    useMemo(
      () =>
        points
          .map(
            (point, index) =>
              `${
                index === 0
                  ? "M"
                  : "L"
              } ${point.x} ${point.y}`,
          )
          .join(" "),
      [points],
    );

  const areaPath =
    useMemo(
      () =>
        buildAreaSvgPath(
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
      {/* Filled volatility area */}
      <Path
        d={areaPath}
        fill={fillColor}
      />

      {/* Volatility line */}
      <Path
        d={linePath}
        fill="none"
        stroke={color}
        strokeWidth={
          ExecutiveChartTheme.chart
            .strokeWidth
        }
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </>
  );
}