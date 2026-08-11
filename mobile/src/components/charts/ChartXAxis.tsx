import React, { useMemo } from "react";
import { View, StyleSheet } from "react-native";

import AppText from "@/components/common/AppText";

import { TimeSeriesPoint, ChartRange } from "./types";
import { buildXAxisLabels } from "./utils/chartLabels";

type Props = {
  width: number;
  data: TimeSeriesPoint[];
  range: ChartRange;
};

export default function ChartXAxis({
  width,
  data,
  range,
}: Props) {
  const labels = useMemo(
    () => buildXAxisLabels(data, range),
    [data, range]
  );

  if (!labels.length) return null;

  return (
    <View
      style={[
        styles.container,
        { width },
      ]}
    >
      {labels.map((label) => (
        <View
          key={label.index}
          style={[
            styles.tick,
            {
              left:
                labels.length === 1
                  ? 0
                  : (label.index / (data.length - 1)) *
                    width,
            },
          ]}
        >
          <View style={styles.marker} />

          <AppText style={styles.text}>
            {label.label}
          </AppText>
        </View>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    height: 38,
    marginTop: 6,
    position: "relative",
  },

  tick: {
    position: "absolute",
    alignItems: "center",
    transform: [{ translateX: -12 }],
  },

  marker: {
    width: 1,
    height: 6,
    backgroundColor: "#CBD5E1",
  },

  text: {
    marginTop: 4,
    fontSize: 10,
    color: "#64748B",
  },
});