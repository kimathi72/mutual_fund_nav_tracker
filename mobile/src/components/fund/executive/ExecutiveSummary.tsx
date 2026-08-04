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
          label="NAV"
          value={formatCurrency(performance.latest_nav)}
        />

        <Metric
          label="Daily"
          value={formatPercentage(performance.daily_return)}
        />

        <Metric
          label="Monthly"
          value={formatPercentage(performance.monthly_return)}
        />

        <Metric
          label="YTD"
          value={formatPercentage(performance.ytd_return)}
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