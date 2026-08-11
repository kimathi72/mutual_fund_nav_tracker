import React from "react";
import {
  View,
  Pressable,
  StyleSheet,
  Text,
} from "react-native";

import { ChartRange } from "./types";

type Props = {
  value: ChartRange;
  onChange: (range: ChartRange) => void;
};

const OPTIONS: {
  label: string;
  value: ChartRange;
}[] = [
  {
    label: "1W",
    value: "1W",
  },
  {
    label: "1M",
    value: "1M",
  },
  {
    label: "3M",
    value: "3M",
  },
  {
    label: "YTD",
    value: "YTD",
  },
  {
    label: "1Y",
    value: "1Y",
  },
  {
    label: "3Y",
    value: "3Y",
  },
  {
    label: "MAX",
    value: "MAX",
  },
];

export default function ChartToolbar({
  value,
  onChange,
}: Props) {
  return (
    <View style={styles.container}>
      {OPTIONS.map(option => {
        const active =
          option.value === value;

        return (
          <Pressable
            key={option.value}
            onPress={() =>
              onChange(option.value)
            }
            style={[
              styles.button,
              active &&
                styles.activeButton,
            ]}
          >
            <Text
              style={[
                styles.label,
                active &&
                  styles.activeLabel,
              ]}
            >
              {option.label}
            </Text>
          </Pressable>
        );
      })}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: "row",
    justifyContent: "flex-end",
    flexWrap: "wrap",
    gap: 8,
    marginBottom: 12,
  },

  button: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 20,
    backgroundColor: "#ECECEC",
  },

  activeButton: {
    backgroundColor: "#1B5E20",
  },

  label: {
    color: "#555",
    fontWeight: "600",
  },

  activeLabel: {
    color: "#FFF",
  },
});