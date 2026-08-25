import React from "react";

import Svg, { Line } from "react-native-svg";

import { getChartDimensions } from "./utils/chartDimensions";

type Props = {
  width: number;

  height: number;
};

export default function ChartGrid({
  width,

  height,
}: Props) {
  const chart = getChartDimensions(width, height);

  const rows = 4;

  return (
    <Svg
      width={width}
      height={height}
      style={{
        position: "absolute",
      }}
    >
      {Array.from({
        length: rows + 1,
      }).map((_, i) => {
        const y = chart.paddingTop + (chart.innerHeight / rows) * i;

        return (
          <Line
            key={i}
            x1={chart.paddingLeft}
            x2={chart.paddingLeft + chart.innerWidth}
            y1={y}
            y2={y}
            stroke="#E5E7EB"
            strokeWidth={1}
          />
        );
      })}
    </Svg>
  );
}
