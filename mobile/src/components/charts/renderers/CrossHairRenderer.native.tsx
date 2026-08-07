import React from "react";

import { Circle, Line, vec } from "@shopify/react-native-skia";

import ExecutiveChartTheme from "../ExecutiveChartTheme";

import { getChartDimensions } from "../utils/chartDimensions";

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

  width,

  height,

  color = ExecutiveChartTheme.colors.crosshair,
}: Props) {
  const chart = getChartDimensions(width, height);

  return (
    <>
      <Line
        p1={vec(
          x,

          chart.paddingTop,
        )}
        p2={vec(
          x,

          chart.paddingTop + chart.innerHeight,
        )}
        color={color}
        strokeWidth={1}
      />

      <Circle cx={x} cy={y} r={5} color={color} />
    </>
  );
}
