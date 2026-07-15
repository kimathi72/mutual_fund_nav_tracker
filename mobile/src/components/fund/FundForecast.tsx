import React from "react";
import { StyleSheet } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import ForecastChart from "@/components/charts/ForecastChart";

import spacing from "@/constants/spacing";

import formatCurrency from "@/utils/formatCurrency";

import {
  ForecastPoint,
  TimeSeriesPoint,
} from "@/components/charts/types";

type Props = {
  history: TimeSeriesPoint[];
  forecast: ForecastPoint[];
  trend: string;
  predictedNav: number;
  confidence: number;
  currency: string;
};

export default function FundForecast({
  history,
  forecast,
  trend,
  predictedNav,
  confidence,
  currency,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <AppText variant="heading">
        AI Forecast
      </AppText>

      <AppText>
        Trend: {trend}
      </AppText>

      <AppText>
        Predicted NAV:{" "}
        {formatCurrency(
          predictedNav,
          currency
        )}
      </AppText>

      <AppText>
        Confidence:{" "}
        {Math.round(confidence * 100)}%
      </AppText>

      <ForecastChart
        history={history}
        forecast={forecast}
      />
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.lg,
  },
});