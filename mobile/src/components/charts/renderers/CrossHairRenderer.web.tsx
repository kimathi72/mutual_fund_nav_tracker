import React from "react";

import {
  Circle,
  Line,
} from "react-native-svg";

import ExecutiveChartTheme from "../ExecutiveChartTheme";

import {
  getChartDimensions,
} from "../utils/chartDimensions";

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

  const chart = getChartDimensions(
    width,
    height
  );

  return (
    <>

      <Line

        x1={x}

        y1={chart.paddingTop}

        x2={x}

        y2={
          chart.paddingTop +
          chart.innerHeight
        }

        stroke={color}

        strokeWidth={1}

        opacity={0.35}

      />

      <Circle

        cx={x}

        cy={y}

        r={5}

        fill={color}

        stroke="#FFFFFF"

        strokeWidth={2}

      />

    </>
  );

}