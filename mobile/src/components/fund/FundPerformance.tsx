import React from "react";
import { StyleSheet, View } from "react-native";

import AppText from "@/components/common/AppText";

import NavHistoryChart from "@/components/charts/NavHistoryChart";

import spacing from "@/constants/spacing";

import formatPercentage from "@/utils/formatPercentage";

import { NavPoint } from "@/models/NavPoint";

import { TimeSeriesPoint } from "@/components/charts/types";

import { ExecutiveFund } from "@/models/ExecutiveFund";

interface Props {
  fund: ExecutiveFund;
  history: NavPoint[];
}

export default function FundPerformance({
  fund,
  history,
}: Props) {
  const chartHistory: TimeSeriesPoint[] = history.map((point) => ({
    date: point.date,
    value: Number(point.nav),
  }));

  return (
    <>

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