import React from "react";

import {
  Circle,
  Line,
  vec,
} from "@shopify/react-native-skia";

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
        p1={vec(x, 0)}
        p2={vec(x, height)}
        color={color}
        strokeWidth={1}
      />

      <Circle
        cx={x}
        cy={y}
        r={5}
        color={color}
      />
    </>
  );
}