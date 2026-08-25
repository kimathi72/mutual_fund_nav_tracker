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

type Props = {
  data: TimeSeriesPoint[];
  width: number;
  height: number;
};

export default function ChartYAxis({
  data,
  height,
}: Props) {
  const domain =
    getChartDomain(data);

  const divisions = 5;

  const labels =
    Array.from({
      length: divisions,
    }).map((_, i) => {
      return (
        domain.max -
        (domain.range * i) /
          (divisions - 1)
      );
    });

  return (
    <View
      style={[
        styles.container,
        {
          height,
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