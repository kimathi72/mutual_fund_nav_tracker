// components/charts/ChartContainer.tsx

import React from "react";

import {
  View,
  StyleSheet,
} from "react-native";

import ChartCard from "./ChartCard";
import ChartToolbar from "./ChartToolbar";
import ChartXAxis from "./ChartXAxis";
import ChartYAxis from "./ChartYAxis";
import ChartGrid from "./ChartGrid";
import ChartSurface from "./ChartSurface";

import useChartDimensions from "./hooks/useChartDimensions";

import type {
  ChartRange,
  TimeSeriesPoint,
} from "./types";

type Props = {
  title: string;

  subtitle?: string;

  rightLabel?: string;

  data: TimeSeriesPoint[];

  range: ChartRange;

  onRangeChange: (
    range: ChartRange,
  ) => void;

  onMove?: (
    x: number,
  ) => void;

  onEnd?: () => void;

  children: (dimensions: {
    width: number;
    height: number;
  }) => React.ReactNode;
};

export default function ChartContainer({
  title,
  subtitle,
  rightLabel,
  data,
  range,
  onRangeChange,
  onMove,
  onEnd,
  children,
}: Props) {
  const {
    width,
    height,
  } =
    useChartDimensions();

  return (
    <ChartCard
      title={title}
      subtitle={subtitle}
      rightLabel={rightLabel}
    >
      <ChartToolbar
        value={range}
        onChange={
          onRangeChange
        }
      />

      <View
        style={
          styles.chartRow
        }
      >
        <ChartYAxis
          data={data}
          width={54}
          height={height}
        />

        <View
          style={
            styles.surfaceContainer
          }
        >
          <View
            style={[
              styles.surfaceLayer,
              {
                width,
                height,
              },
            ]}
          >
            <ChartGrid
              width={width}
              height={height}
            />

            <ChartSurface
              width={width}
              height={height}
              onMove={onMove}
              onEnd={onEnd}
            >
              {({
                width: innerWidth,
                height: innerHeight,
              }) =>
                children({
                  width: innerWidth,
                  height: innerHeight,
                })
              }
            </ChartSurface>
          </View>

          <ChartXAxis
            width={width}
            data={data}
            range={range}
          />
        </View>
      </View>
    </ChartCard>
  );
}

const styles =
  StyleSheet.create({
    chartRow: {
      width: "100%",

      flexDirection:
        "row",

      alignItems:
        "flex-start",

      minWidth: 0,
    },

    surfaceContainer: {
      flex: 1,

      minWidth: 0,

      overflow:
        "hidden",
    },

    surfaceLayer: {
      position:
        "relative",
    },
  });