import React, { useMemo } from "react";
import {
  Canvas,
  Path,
} from "@shopify/react-native-skia";

import { AreaRendererProps } from "../types";

import { toChartPoints } from "../utils/chartMath";
import { buildAreaPath } from "../utils/chartArea.native";
import { buildLinePath } from "../utils/chartPath";

import ExecutiveChartTheme from "../ExecutiveChartTheme";

export default function AreaRenderer({
  data,
  width,
  height,
  color = ExecutiveChartTheme.colors.historical,
  fillColor = ExecutiveChartTheme.colors.surface,
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

  const line = useMemo(
    () => buildLinePath(points),
    [points]
  );

  const area = useMemo(
    () => buildAreaPath(points, height),
    [points, height]
  );

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
        strokeWidth={
          ExecutiveChartTheme.chart.strokeWidth
        }
      />
    </Canvas>
  );
}