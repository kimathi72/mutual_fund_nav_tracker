import React from "react";

import {
  Circle,
  Line,
} from "react-native-svg";

type Props = {
  x: number;

  y: number;

  height: number;

  color?: string;
};

export default function CrosshairRenderer({
  x,
  y,
  height,
  color = "#2563EB",
}: Props) {
  return (
    <>
      <Line
        x1={x}
        y1={0}
        x2={x}
        y2={height}
        stroke={color}
        strokeWidth={1}
        opacity={0.35}
      />

      <Circle
        cx={x}
        cy={y}
        r={5}
        fill={color}
        stroke="white"
        strokeWidth={2}
      />
    </>
  );
}