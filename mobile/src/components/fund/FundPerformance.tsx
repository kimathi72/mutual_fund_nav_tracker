import React from "react";
import { StyleSheet, View } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import NavHistoryChart from "@/components/charts/NavHistoryChart";

import spacing from "@/constants/spacing";

import formatPercentage from "@/utils/formatPercentage";

import { PerformanceReport } from "@/models/PerformanceReport";
import { NavPoint } from "@/models/NavPoint";

import { TimeSeriesPoint } from "@/components/charts/types";

interface Props {
  performance: PerformanceReport;
  history: NavPoint[];
}

export default function FundPerformance({
  performance,
  history,
}: Props) {
  const chartHistory: TimeSeriesPoint[] = history.map((point) => ({
    date: point.date,
    value: Number(point.nav),
  }));

  return (
    <>
      <AppCard style={styles.card}>
        <AppText variant="heading">
          Performance
        </AppText>

        <Metric
          label="Daily"
          value={performance.daily_return}
        />

        <Metric
          label="Weekly"
          value={performance.weekly_return}
        />

        <Metric
          label="Monthly"
          value={performance.monthly_return}
        />

        <Metric
          label="YTD"
          value={performance.ytd_return}
        />

        <Metric
          label="MA (7)"
          value={performance.moving_average_7}
        />

        <Metric
          label="MA (30)"
          value={performance.moving_average_30}
        />
      </AppCard>

      <NavHistoryChart
        history={chartHistory}
      />
    </>
  );
}

type MetricProps = {
  label: string;
  value: number;
};

function Metric({
  label,
  value,
}: MetricProps) {
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