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

export default function ExecutiveSummary({
  fund,
}: Props) {
  const performance = fund.performance;

  // Always use the currency belonging to the current fund.
  const currency = fund.performance.currency ?? "USD";

  return (
    <AppCard style={styles.card}>
      <AppText
        variant="title"
        style={styles.title}
      >
        Executive Snapshot
      </AppText>

      <View style={styles.row}>
        <Metric
          label="Latest NAV"
          value={formatCurrency(
            performance.latest_nav,
            currency,
          )}
        />

        <Metric
          label="Daily returns"
          value={formatPercentage(
            performance.daily_return,
          )}
        />

        <Metric
          label="Monthly returns"
          value={formatPercentage(
            performance.monthly_return,
          )}
        />

        <Metric
          label="Year-To-Date returns"
          value={formatPercentage(
            performance.ytd_return,
          )}
        />

        <Metric
          label="Moving Avg 7 days"
          value={formatCurrency(
            performance.moving_average_7,
            currency,
          )}
        />

        <Metric
          label="Moving Avg 30 days"
          value={formatCurrency(
            performance.moving_average_30,
            currency,
          )}
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
      <AppText
        variant="caption"
        color="#64748B"
        style={styles.label}
      >
        {label}
      </AppText>

      <AppText
        variant="heading"
        style={styles.value}
      >
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

  title: {
    marginBottom: 8,
  },

  row: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "flex-start",
    marginTop: 15,
    gap: 12,
  },

  metric: {
    alignItems: "center",
    justifyContent: "flex-start",
    flex: 1,
    minWidth: 0,
  },

  label: {
    textAlign: "center",
    marginBottom: 4,
  },

  value: {
    textAlign: "center",
  },
});