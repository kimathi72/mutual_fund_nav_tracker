import React from "react";
import { StyleSheet } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import {
  VolatilityChart,
} from "@/components/charts";

import spacing from "@/constants/spacing";

import riskColor from "@/utils/riskColor";
import formatPercentage from "@/utils/formatPercentage";

import { RiskReport } from "@/models/RiskReport";
import { VolatilityPoint } from "@/models/VolatilityPoint";

interface Props {
  risk: RiskReport;
  history: VolatilityPoint[];
}

export default function FundRisk({
  risk,
  history,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <AppText variant="body">
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
        history={history ?? []}
      />
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.lg,
  },
});
