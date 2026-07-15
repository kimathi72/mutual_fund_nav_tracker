import React from "react";
import { Dimensions } from "react-native";

import ChartCard from "./ChartCard";

import ChartCanvas from "./skia/ChartCanvas";
import LinePath from "./skia/LinePath";

import ExecutiveChartTheme from "./ExecutiveChartTheme";

type Point = {

  date: string;

  volatility: number;

};

type Props = {

  history: Point[];

};

const WIDTH = Dimensions.get("window").width - 48;

const HEIGHT = 180;

export default function VolatilityChart({

  history,

}: Props) {

  if (!history.length)
    return null;

  return (

    <ChartCard title="30-Day Volatility">

      <ChartCanvas
        width={WIDTH}
        height={HEIGHT}
      >

        <LinePath
          values={
            history.map(
              h => h.volatility
            )
          }
          width={WIDTH}
          height={HEIGHT}
          color={ExecutiveChartTheme.negative}
        />

      </ChartCanvas>

    </ChartCard>

  );

}