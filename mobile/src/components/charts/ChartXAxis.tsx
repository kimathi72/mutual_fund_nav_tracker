import React from "react";
import {
  View,
  Text,
  StyleSheet,
} from "react-native";

type Tick = {
  index: number;
  label: string;
};

type Props = {
  ticks: Tick[];
  chartWidth: number;
  totalPoints: number;
};

export default function ChartXAxis({
  ticks,
  chartWidth,
  totalPoints,
}: Props) {
  return (
    <View
      style={[
        styles.container,
        {
          width: chartWidth,
        },
      ]}
    >
      {ticks.map((tick) => {
        const left =
          totalPoints <= 1
            ? 0
            : (tick.index /
                (totalPoints - 1)) *
              chartWidth;

        return (
          <View
            key={`${tick.index}-${tick.label}`}
            style={[
              styles.tickContainer,
              {
                left,
              },
            ]}
          >
            <View style={styles.tick} />

            <Text style={styles.label}>
              {tick.label}
            </Text>
          </View>
        );
      })}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    height: 40,
    marginTop: 6,
    position: "relative",
  },

  tickContainer: {
    position: "absolute",
    alignItems: "center",
    transform: [
      {
        translateX: -12,
      },
    ],
  },

  tick: {
    width: 1,
    height: 6,
    backgroundColor: "#A0A0A0",
  },

  label: {
    marginTop: 4,
    fontSize: 10,
    color: "#777",
  },
});