
import React from "react";
import {
  ScrollView,
  StyleSheet,
  View,
} from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import ForecastChart from "@/components/charts/ForecastChart";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

import formatCurrency from "@/utils/formatCurrency";

import {
  Forecast,
  ForecastReport,
} from "@/models/Forecast";

import { NavPoint } from "@/models/NavPoint";
import { PredictionPoint } from "@/models/PredictionPoint";

import {
  TimeSeriesPoint,
  ForecastPoint,
} from "@/components/charts/types";

interface Props {
  report: ForecastReport;
  history: NavPoint[];
  forecastSeries: PredictionPoint[];
  currency: string;
}

export default function FundForecast({
  report,
  history,
  forecastSeries,
  currency,
}: Props) {
  const historySeries: TimeSeriesPoint[] = history.map(
    (point) => ({
      date: point.date,
      value: Number(point.nav),
    }),
  );

  const predictionSeries: ForecastPoint[] =
    forecastSeries.map((point) => ({
      date: point.target_date,
      value: Number(point.predicted_nav),
      lower: Number(point.lower_bound),
      upper: Number(point.upper_bound),
    }));

  return (
    <AppCard style={styles.card}>
      <AppText
        variant="heading"
        style={styles.sectionTitle}
      >
        AI Forecast
      </AppText>

      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.forecastScroll}
      >
        {report.predictions.map(
          (prediction: Forecast) => (
            <ForecastCard
              key={`${prediction.horizon}-${prediction.target_date}`}
              prediction={prediction}
              currency={currency}
            />
          ),
        )}
      </ScrollView>

      <AppText
        variant="heading"
        style={styles.chartTitle}
      >
        Forecast Chart
      </AppText>

      <ForecastChart
        history={historySeries}
        forecast={predictionSeries}
      />
    </AppCard>
  );
}

function ForecastCard({
  prediction,
  currency,
}: {
  prediction: Forecast;
  currency: string;
}) {
  const horizonLabel = getHorizonLabel(
    prediction.horizon,
  );

  const expectedReturn = Number(
    prediction.expected_return_pct ?? 0,
  );

  const confidence =
    Number(prediction.confidence_score ?? 0) * 100;

  const trend = String(
    prediction.trend ?? "",
  );

  const recommendation = String(
    prediction.recommendation ?? "",
  );

  const returnColor =
    expectedReturn >= 0
      ? colors.success
      : colors.danger;

  const trendColor =
    trend.toLowerCase() === "bullish"
      ? colors.success
      : trend.toLowerCase() === "bearish"
        ? colors.danger
        : colors.warning;

  const recommendationColor =
    recommendation.toLowerCase().includes("buy")
      ? colors.success
      : recommendation.toLowerCase().includes("sell")
        ? colors.danger
        : colors.warning;

  return (
    <View style={styles.forecastCard}>
      <View style={styles.horizonContainer}>
        <AppText
          variant="body"
          style={styles.horizon}
        >
          {horizonLabel}
        </AppText>
      </View>

      <View style={styles.metricBlock}>
        <AppText
          variant="caption"
          color={colors.subtitle}
        >
          Predicted NAV
        </AppText>

        <AppText
          variant="body"
          style={styles.metricValue}
        >
          {formatCurrency(
            prediction.predicted_nav ?? 0,
            currency,
          )}
        </AppText>
      </View>

      <View style={styles.metricBlock}>
        <AppText
          variant="caption"
          color={colors.subtitle}
        >
          Expected Return
        </AppText>

        <AppText
          variant="body"
          color={returnColor}
          style={styles.metricValue}
        >
          {Number.isFinite(expectedReturn)
            ? `${expectedReturn >= 0 ? "+" : ""}${expectedReturn.toFixed(2)}%`
            : "—"}
        </AppText>
      </View>

      <View style={styles.metricBlock}>
        <AppText
          variant="caption"
          color={colors.subtitle}
        >
          Prediction Confidence
        </AppText>

        <AppText
          variant="body"
          style={styles.metricValue}
        >
          {Number.isFinite(confidence)
            ? `${confidence.toFixed(0)}%`
            : "—"}
        </AppText>
      </View>

      <View style={styles.metricBlock}>
        <AppText
          variant="caption"
          color={colors.subtitle}
        >
          Market Trend
        </AppText>

        <AppText
          variant="body"
          color={trendColor}
          style={styles.metricValue}
        >
          {trend || "—"}
        </AppText>
      </View>

      <View style={styles.metricBlock}>
        <AppText
          variant="caption"
          color={colors.subtitle}
        >
          Recommendation
        </AppText>

        <AppText
          variant="body"
          color={recommendationColor}
          style={styles.metricValue}
        >
          {recommendation || "—"}
        </AppText>
      </View>
    </View>
  );
}

function getHorizonLabel(
  horizon: string | undefined,
): string {
  switch (String(horizon).toLowerCase()) {
    case "1d":
      return "1 Day";

    case "30d":
      return "30 Days";

    case "90d":
      return "90 Days";

    default:
      return horizon ?? "Forecast";
  }
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.lg,
  },

  sectionTitle: {
    marginBottom: spacing.md,
  },

  forecastScroll: {
    gap: spacing.md,
    paddingBottom: spacing.sm,
  },

  forecastCard: {
    width: 230,
    padding: spacing.md,
    borderRadius: 14,
    backgroundColor: colors.background,
    borderWidth: 1,
    borderColor: colors.border,
  },

  horizonContainer: {
    marginBottom: spacing.md,
    paddingBottom: spacing.sm,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: colors.border,
  },

  horizon: {
    fontWeight: "700",
    fontSize: 16,
  },

  metricBlock: {
    marginBottom: spacing.sm,
  },

  metricValue: {
    marginTop: 2,
    fontWeight: "600",
  },

  chartTitle: {
    marginTop: spacing.lg,
    marginBottom: spacing.md,
  },
});
