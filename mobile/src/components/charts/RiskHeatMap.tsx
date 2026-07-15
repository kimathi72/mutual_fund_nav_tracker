import React from "react";
import { View, StyleSheet } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import spacing from "@/constants/spacing";

import riskColor from "@/utils/riskColor";
import formatPercentage from "@/utils/formatPercentage";

type Props = {
  value: number;
};

export default function RiskHeatMap({
  value,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <AppText variant="heading">
        Risk Level
      </AppText>

      <View
        style={[
          styles.bar,
          {
            backgroundColor: riskColor(value),
          },
        ]}
      />

      <AppText variant="caption">
        Current Volatility
      </AppText>

      <AppText>
        {formatPercentage(value)}
      </AppText>
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginTop: spacing.md,
  },

  bar: {
    height: 18,
    borderRadius: 10,
    marginVertical: spacing.md,
  },
});