import React from "react";
import { StyleSheet } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import {
  RiskHeatMap,
  VolatilityChart,
} from "@/components/charts";

import spacing from "@/constants/spacing";

import formatPercentage from "@/utils/formatPercentage";
import riskColor from "@/utils/riskColor";

import {
  HeatMapCell,
  TimeSeriesPoint,
} from "@/components/charts/types";

type Props = {
  volatility: number;
  drawdown: number;
  ytdReturn: number;
  history: TimeSeriesPoint[];
};

export default function FundRisk({
  volatility,
  drawdown,
  ytdReturn,
  history,
}: Props) {
  const heatMapData: HeatMapCell[] = [
    {
      label: "Volatility",
      value: volatility,
    },
    {
      label: "Drawdown",
      value: Math.abs(drawdown),
    },
    {
      label: "YTD",
      value: Math.abs(ytdReturn),
    },
  ];

  return (
    <AppCard style={styles.card}>
      <AppText variant="heading">
        Risk Analysis
      </AppText>

      <AppText
        style={{
          color: riskColor(volatility),
        }}
      >
        Volatility: {formatPercentage(volatility)}
      </AppText>

      <AppText>
        Drawdown: {formatPercentage(drawdown)}
      </AppText>

      <VolatilityChart history={history} />

      <RiskHeatMap data={heatMapData} />
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.lg,
  },
});