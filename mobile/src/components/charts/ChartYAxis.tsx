import React from "react";
import { View, Text, StyleSheet } from "react-native";

type Props = {
  min: number;
  max: number;
  height: number;
};

export default function ChartYAxis({ min, max, height }: Props) {
  const divisions = 5;

  const values = Array.from({
    length: divisions,
  }).map((_, i) => {
    return max - ((max - min) * i) / (divisions - 1);
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
      {values.map((value) => (
        <Text key={value} style={styles.label}>
          {value.toFixed(2)}
        </Text>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    justifyContent: "space-between",
    width: 54,
    paddingRight: 8,
  },

  label: {
    textAlign: "right",
    color: "#777",
    fontSize: 10,
  },
});
