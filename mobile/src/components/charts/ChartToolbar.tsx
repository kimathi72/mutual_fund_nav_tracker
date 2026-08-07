import React from "react";
import {
  View,
  Pressable,
  StyleSheet,
} from "react-native";
import { Text } from "react-native";

export type ChartRange =
  | "week"
  | "month"
  | "year";

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
    value: "week",
  },
  {
    label: "1M",
    value: "month",
  },
  {
    label: "1Y",
    value: "year",
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
    marginBottom: 12,
    gap: 8,
  },

  button: {
    paddingHorizontal: 14,
    paddingVertical: 6,
    borderRadius: 20,
    backgroundColor: "#ECECEC",
  },

  activeButton: {
    backgroundColor: "#1B5E20",
  },

  label: {
    fontWeight: "600",
    color: "#555",
  },

  activeLabel: {
    color: "#FFFFFF",
  },
});