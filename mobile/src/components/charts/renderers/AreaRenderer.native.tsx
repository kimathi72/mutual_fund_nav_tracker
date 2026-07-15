import React, {
  useMemo,
} from "react";

import {
  Canvas,
  Path,
} from "@shopify/react-native-skia";

import {
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

  const line = useMemo(
    () => buildLinePath(points),
    [points]
  );

  const area = useMemo(
    () =>
      buildAreaPath(
        points,
        height
      ),
    [points, height]
  );

  if (points.length < 2) {
    return null;
  }

  return (
    <Canvas
      style={{
        width,
        height,
      }}
    >
      <Path
        path={area}
        color={fillColor}
      />

      <Path
        path={line}
        color={color}
        style="stroke"
        strokeWidth={3}
      />
    </Canvas>
  );
}