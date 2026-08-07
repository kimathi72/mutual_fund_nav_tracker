import React, { useMemo } from "react";
import Svg, { Path } from "react-native-svg";

import { AreaRendererProps } from "../types";

import { toChartPoints } from "../utils/chartMath";
import { buildAreaSvgPath } from "../utils/chartArea";
import { getChartDimensions } from "../utils/chartDimensions";

import ExecutiveChartTheme from "../ExecutiveChartTheme";

export default function AreaRenderer({
  data,

  width,

  height,

  color = ExecutiveChartTheme.colors.historical,

  fillColor = ExecutiveChartTheme.colors.surface,
}: AreaRendererProps) {
  const chart = getChartDimensions(width, height);

  const points = useMemo(
    () =>
      toChartPoints(data, chart.innerWidth, chart.innerHeight).map((point) => ({
        x: point.x + chart.paddingLeft,
        y: point.y + chart.paddingTop,
      })),
    [data, chart],
  );

  if (points.length < 2) {
    return null;
  }

  const line = points
    .map((p, i) => `${i === 0 ? "M" : "L"} ${p.x} ${p.y}`)
    .join(" ");

  const area = buildAreaSvgPath(points, chart.paddingTop + chart.innerHeight);

  return (
    <Svg
      width={width}
      height={height}
      style={{
        position: "absolute",
      }}
    >
      <Path d={area} fill={fillColor} />

      <Path
        d={line}
        stroke={color}
        strokeWidth={ExecutiveChartTheme.chart.strokeWidth}
        fill="none"
      />
    </Svg>
  );
}
