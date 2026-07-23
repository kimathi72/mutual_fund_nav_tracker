import React from "react";
import { StyleSheet, View } from "react-native";

import KPICard from "./KPICard";

import type { PortfolioSummary } from "@/models/PortfolioSummary";

import formatPercentage from "@/utils/formatPercentage";

import spacing from "@/constants/spacing";

interface Props {
  summary: PortfolioSummary;
}

export default function KPIGrid({
  summary,
}: Props) {
  return (
    <View style={styles.container}>
      <View style={styles.row}>
        <KPICard
          title="Funds"
          value={summary.total_funds}
          subtitle="Active Funds"
        />

        <KPICard
          title="Daily"
          value={formatPercentage(
            summary.average_daily_return
          )}
        />
      </View>

      <View style={styles.row}>
        <KPICard
          title="Weekly"
          value={formatPercentage(
            summary.average_weekly_return
          )}
        />

        <KPICard
          title="Monthly"
          value={formatPercentage(
            summary.average_monthly_return
          )}
        />
      </View>

      <View style={styles.row}>
        <KPICard
          title="YTD"
          value={formatPercentage(
            summary.average_ytd_return
          )}
        />

        <KPICard
          title="Volatility"
          value={formatPercentage(
            summary.average_volatility
          )}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    gap: spacing.md,
    marginHorizontal: spacing.md,
    marginBottom: spacing.md,
  },

  row: {
    flexDirection: "row",
    gap: spacing.md,
  },
});