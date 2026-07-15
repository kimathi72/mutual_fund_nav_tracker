import React from "react";
import { Dimensions } from "react-native";

import ChartCard from "./ChartCard";

import ChartCanvas from "./skia/ChartCanvas";
import LinePath from "./skia/LinePath";

import ExecutiveChartTheme from "./ExecutiveChartTheme";

type NavPoint = {
  date: string;
  nav: number;
};

type Props = {
  history: NavPoint[];
};

const WIDTH = Dimensions.get("window").width - 48;
const HEIGHT = 220;

export default function NavHistoryChart({
  history,
}: Props) {

  if (!history.length) return null;

  return (

    <ChartCard
      title="NAV History"
      subtitle={`${history.length} trading days`}
    >

      <ChartCanvas
        width={WIDTH}
        height={HEIGHT}
      >

        <LinePath
          values={history.map(p => p.nav)}
          width={WIDTH}
          height={HEIGHT}
          color={ExecutiveChartTheme.line}
        />

      </ChartCanvas>

    </ChartCard>

  );

}