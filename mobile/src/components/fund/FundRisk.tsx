import React from "react";
import { StyleSheet } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import {
  RiskHeatMap,
  VolatilityChart,
} from "@/components/charts";

import spacing from "@/constants/spacing";

import riskColor from "@/utils/riskColor";
import formatPercentage from "@/utils/formatPercentage";

import { RiskReport } from "@/models/RiskReport";

interface Props {
  risk: RiskReport;

  history: {
    date: string;
    value: number;
  }[];
}

export default function FundRisk({
  risk,
  history,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <AppText variant="heading">
        Risk Analysis
      </AppText>

      <AppText
        style={{
          color: riskColor(risk.risk_level),
        }}
      >
        Risk Level: {risk.risk_level}
      </AppText>

      <AppText>
        Volatility:{" "}
        {formatPercentage(risk.volatility_30)}
      </AppText>

      <AppText>
        Drawdown:{" "}
        {formatPercentage(risk.drawdown)}
      </AppText>

      <VolatilityChart
        history={history}
      />

      <RiskHeatMap
        data={[
          {
            label: "Volatility",
            value: Number(risk.volatility_30),
          },
          {
            label: "Drawdown",
            value: Math.abs(Number(risk.drawdown)),
          }
        ]}
      />
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.lg,
  },
});