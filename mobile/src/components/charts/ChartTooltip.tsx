import React from "react";

import {
  StyleSheet,
  View,
} from "react-native";

import AppText from "../common/AppText";

import colors from "@/constants/colors";

import spacing from "@/constants/spacing";

type Props = {
  x: number;

  y: number;

  label: string;

  value: string;

  visible: boolean;
};

export default function ChartTooltip({
  x,
  y,
  label,
  value,
  visible,
}: Props) {
  if (!visible) {
    return null;
  }

  return (
    <View
      pointerEvents="none"
      style={[
        styles.container,
        {
          left: x,
          top: y,
        },
      ]}
    >
      <AppText
        variant="caption"
      >
        {label}
      </AppText>

      <AppText
        weight="bold"
      >
        {value}
      </AppText>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    position: "absolute",

    backgroundColor:
      colors.background,

    padding:
      spacing.sm,

    borderRadius: 8,

    elevation: 3,

    shadowOpacity: 0.15,

    shadowRadius: 6,

    shadowOffset: {
      width: 0,
      height: 2,
    },
  },
});