// src/components/dashboard/KPIGrid.tsx

import { View, StyleSheet } from "react-native";

import KPICard from "./KPICard";

import { PortfolioSummary } from "@/models/PortfolioSummary";

import  formatPercentage  from "@/utils/formatPercentage";

import  spacing  from "@/constants/spacing";

type Props = {
  summary: PortfolioSummary;
};

export default function KPIGrid({
  summary,
}: Props) {
  return (
    <View style={styles.container}>
      <View style={styles.row}>
        <KPICard
          title="Funds"
          value={summary.total_funds}
          subtitle="Active"
        />

        <KPICard
          title="YTD Return"
          value={formatPercentage(summary.average_ytd_return)}
        />
      </View>

      <View style={styles.row}>
        <KPICard
          title="Daily Return"
          value={formatPercentage(summary.average_daily_return)}
        />

        <KPICard
          title="Volatility"
          value={formatPercentage(summary.average_volatility)}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    gap: spacing.md,
  },

  row: {
    flexDirection: "row",
    gap: spacing.md,
  },
});