import React, { useMemo } from "react";
import { Path } from "@shopify/react-native-skia";

import { RendererProps } from "../types";

import { toChartPoints } from "../utils/chartMath";
import { buildLinePath } from "../utils/chartPath";

import ExecutiveChartTheme from "../ExecutiveChartTheme";

export default function SparklineRenderer({
  data,
  width,
  height,
  color = ExecutiveChartTheme.colors.historical,
  strokeWidth = 2,
}: RendererProps) {
  const path = useMemo(() => {
    const points = toChartPoints(
      data,
      width,
      height
    );

    return buildLinePath(points);
  }, [data, width, height]);

  if (data.length < 2) {
    return null;
  }

  return (
    <Path
      path={path}
      color={color}
      style="stroke"
      strokeWidth={strokeWidth}
    />
  );
}