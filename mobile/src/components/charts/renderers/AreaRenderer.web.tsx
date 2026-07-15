import React, {
  useMemo,
} from "react";

import Svg, {
  Path,
} from "react-native-svg";

import {
  AreaRendererProps,
} from "../types";

import {
  toChartPoints,
} from "../utils/chartMath";

import {
  buildAreaSvgPath,
} from "../utils/chartArea";

export default function AreaRenderer({
  data,
  width,
  height,
  color = "#1E3A8A",
  fillColor = "rgba(30,58,138,0.15)",
}: AreaRendererProps) {

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

  const line = points
    .map(
      (p, i) =>
        `${i === 0 ? "M" : "L"} ${p.x} ${p.y}`
    )
    .join(" ");

  const area =
    buildAreaSvgPath(
      points,
      height
    );

  return (
    <Svg
      width={width}
      height={height}
    >
      <Path
        d={area}
        fill={fillColor}
      />

      <Path
        d={line}
        stroke={color}
        strokeWidth={3}
        fill="none"
      />
    </Svg>
  );
}