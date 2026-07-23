import React from "react";
import { StyleSheet, View } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import spacing from "@/constants/spacing";

import formatPercentage from "@/utils/formatPercentage";

import { PerformanceReport } from "@/models/PerformanceReport";

interface Props {
  performance: PerformanceReport;
}

export default function FundPerformance({
  performance,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <AppText variant="heading">
        Performance
      </AppText>

      <Metric
        label="Daily"
        value={Number(performance.daily_return)}
      />

      <Metric
        label="Weekly"
        value={Number(performance.weekly_return)}
      />

      <Metric
        label="Monthly"
        value={Number(performance.monthly_return)}
      />

      <Metric
        label="YTD"
        value={Number(performance.ytd_return)}
      />

      <Metric
        label="MA (7)"
        value={Number(performance.moving_average_7)}
      />

      <Metric
        label="MA (30)"
        value={Number(performance.moving_average_30)}
      />
    </AppCard>
  );
}

function Metric({
  label,
  value,
}: {
  label: string;
  value: number;
}) {
  return (
    <View style={styles.metric}>
      <AppText>{label}</AppText>

      <AppText>
        {formatPercentage(value)}
      </AppText>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.lg,
  },

  metric: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginTop: spacing.md,
  },
});