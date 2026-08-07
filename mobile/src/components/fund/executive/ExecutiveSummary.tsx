import React from "react";
import { View, StyleSheet } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import { ExecutiveFund } from "@/models/ExecutiveFund";

import formatCurrency from "@/utils/formatCurrency";
import formatPercentage from "@/utils/formatPercentage";

interface Props {
  fund: ExecutiveFund;
}

export default function ExecutiveSummary({ fund }: Props) {

  const performance = fund.performance;

  return (
    <AppCard style={styles.card}>

      <AppText variant="title">
        Executive Snapshot
      </AppText>

      <View style={styles.row}>

        <Metric
          label="latest NAV"
          value={formatCurrency(performance.latest_nav)}
        />

        <Metric
          label="Daily returns"
          value={formatPercentage(performance.daily_return)}
        />

        <Metric
          label="Monthly returns"
          value={formatPercentage(performance.monthly_return)}
        />

        <Metric
          label="Year-To-Date returns"
          value={formatPercentage(performance.ytd_return)}
        />
        <Metric
          label="Moving-Avg-7days"
          value={formatCurrency(performance.moving_average_7)}
        />
        <Metric
          label="Moving-Avg-30days"
          value={formatCurrency(performance.moving_average_30)}
        />

      </View>

    </AppCard>
  );
}

function Metric({
  label,
  value,
}: {
  label: string;
  value: string;
}) {
  return (
    <View style={styles.metric}>
      <AppText variant="caption">
        {label}
      </AppText>

      <AppText variant="heading">
        {value}
      </AppText>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    padding: 16,
    marginTop: 12,
  },

  row: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginTop: 15,
  },

  metric: {
    alignItems: "center",
    flex: 1,
  },
});