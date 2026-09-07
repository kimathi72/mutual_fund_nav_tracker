import React from "react";

import {
  View,
  Text,
  StyleSheet,
} from "react-native";

import {
  TimeSeriesPoint,
} from "./types";

import {
  getChartDomain,
} from "./utils/chartMath";

import {
  getChartDimensions,
} from "./utils/chartDimensions";

type Props = {
  data: TimeSeriesPoint[];
  width: number;
  height: number;
};

export default function ChartYAxis({
  data,
  width,
  height,
}: Props) {
  const domain =
    getChartDomain(data);

  const chart =
    getChartDimensions(
      width,
      height,
    );

  const divisions = 5;

  const labels =
    Array.from({
      length: divisions,
    }).map((_, i) => {
      return (
        domain.max -
        (
          domain.range * i
        ) /
        (divisions - 1)
      );
    });

  return (
    <View
      style={[
        styles.container,
        {
          width,
          height,

          paddingTop:
            chart.paddingTop,

          paddingBottom:
            chart.paddingBottom,
        },
      ]}
    >
      {labels.map(value => (
        <Text
          key={value}
          style={styles.label}
        >
          {value.toFixed(2)}
        </Text>
      ))}
    </View>
  );
}

const styles =
  StyleSheet.create({
    container: {
      width: 56,

      paddingRight: 8,

      justifyContent:
        "space-between",
    },

    label: {
      textAlign: "right",

      color: "#777",

      fontSize: 10,
    },
  });