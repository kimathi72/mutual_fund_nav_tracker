import React, {
  useMemo,
} from "react";

import {
  Path,
} from "@shopify/react-native-skia";

import {
  RendererProps,
} from "../types";

import {
  toChartPoints,
} from "../utils/chartMath";

import {
  buildLinePath,
} from "../utils/chartPath";

export default function LineRenderer({
  data,
  width,
  height,
  color = "#1E3A8A",
  strokeWidth = 3,
}: RendererProps) {
  const path = useMemo(() => {
    return buildLinePath(
      toChartPoints(
        data,
        width,
        height
      )
    );
  }, [
    data,
    width,
    height,
  ]);

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