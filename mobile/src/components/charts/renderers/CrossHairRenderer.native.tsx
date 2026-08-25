import React from "react";
import {
  Circle,
  Line,
  vec,
} from "@shopify/react-native-skia";

import ExecutiveChartTheme from "../ExecutiveChartTheme";

type Props = {
  x: number;
  y: number;
  width: number;
  height: number;
  color?: string;
};

export default function CrossHairRenderer({
  x,
  y,
  height,
  color = ExecutiveChartTheme.colors.crosshair,
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