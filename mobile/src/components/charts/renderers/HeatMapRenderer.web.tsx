import React from "react";

import Svg, {
  Rect,
} from "react-native-svg";

import { HeatMapProps } from "../types";

function interpolate(value: number) {
  if (value >= 0.75) return "#DC2626";
  if (value >= 0.50) return "#F59E0B";
  if (value >= 0.25) return "#FACC15";
  return "#16A34A";
}

export default function HeatMapRenderer({
  data,
  width,
  height,
}: HeatMapProps) {
  if (!data.length) {
    return null;
  }

  const cellWidth = width / data.length;

  return (
    <Svg
      width={width}
      height={height}
    >
      {data.map((cell, index) => (
        <Rect
          key={cell.label}
          x={index * cellWidth}
          y={0}
          width={cellWidth - 6}
          height={height}
          rx={8}
          ry={8}
          fill={interpolate(cell.value)}
        />
      ))}
    </Svg>
  );
}