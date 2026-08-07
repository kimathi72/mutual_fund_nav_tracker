import React from "react";
import {
  View,
  StyleSheet,
} from "react-native";

import ChartGrid from "./ChartGrid";
import ChartSurface from "./ChartSurface";
import ChartXAxis from "./ChartXAxis";
import ChartYAxis from "./ChartYAxis";

import useChartDimensions from "./hooks/useChartDimensions";

import {
  buildXAxisLabels,
} from "./utils/chartLabels";

import {
  filterChartData,
  ChartRange,
} from "./utils/chartFilters";

import {
  getMinValue,
  getMaxValue,
} from "./utils/chartMath";

import {
  TimeSeriesPoint,
} from "./types";

type Props = {
  data: TimeSeriesPoint[];

  range: ChartRange;

  children: React.ReactNode;

  onMove?: any;

  onEnd?: any;
};

export default function ChartContainer({
  data,
  range,
  children,
  onMove,
  onEnd,
}: Props) {
  const chart =
    useChartDimensions();

  const filtered =
    filterChartData(
      data,
      range
    );

  const ticks =
    buildXAxisLabels(
      filtered,
      range
    );

  const min =
    getMinValue(filtered);

  const max =
    getMaxValue(filtered);

  return (
    <View
      style={styles.wrapper}
    >
      <ChartYAxis
        min={min}
        max={max}
        height={chart.height}
      />

      <View>
        <ChartGrid
          width={chart.width}
          height={chart.height}
        />

        <ChartSurface
          width={chart.width}
          height={chart.height}
          onMove={onMove}
          onEnd={onEnd}
        >
          {children}
        </ChartSurface>

        <ChartXAxis
          ticks={ticks}
          chartWidth={chart.width}
          totalPoints={
            filtered.length
          }
        />
      </View>
    </View>
  );
}

const styles =
  StyleSheet.create({
    wrapper: {
      flexDirection: "row",
      alignItems: "flex-start",
    },
  });