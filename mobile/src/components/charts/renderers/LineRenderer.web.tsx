import React from "react";

import { Polyline } from "react-native-svg";

import useChartScale from "../hooks/useChartScale";

import { RendererProps } from "../types";

export default function LineRenderer({
  data,
  width,
  height,
  color = "#1E3A8A",
  strokeWidth = 3,
  dashed = false,
}: RendererProps) {
  const points = useChartScale(
    data,
    width,
    height
  );

  if (points.length < 2) {
    return null;
  }

  return (
    <Polyline
      points={points
        .map((p) => `${p.x},${p.y}`)
        .join(" ")}
      fill="none"
      stroke={color}
      strokeWidth={strokeWidth}
      strokeDasharray={
        dashed
          ? "8 6"
          : undefined
      }
    />
  );
}