// components/funds/FundForecast.tsx
// Adjust the path above if FundForecast lives elsewhere.

import React, {
  useMemo,
} from "react";

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

import type {
  Forecast,
  ForecastReport,
} from "@/models/Forecast";

import type {
  NavPoint,
} from "@/models/NavPoint";

import type {
  PredictionPoint,
} from "@/models/PredictionPoint";

import type {
  PredictionHistoryPoint,
  TimeSeriesPoint,
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
  /*
  |--------------------------------------------------------------------------
  | Historical NAV
  |--------------------------------------------------------------------------
  */

  const historySeries =
    useMemo<TimeSeriesPoint[]>(
      () =>
        history
          .filter(
            (point) =>
              point.date &&
              Number.isFinite(
                Number(point.nav),
              ),
          )
          .map(
            (point) => ({
              date: point.date,
              value: Number(
                point.nav,
              ),
            }),
          ),
      [history],
    );

  /*
  |--------------------------------------------------------------------------
  | Split prediction history by horizon
  |--------------------------------------------------------------------------
  |
  | The chart now has three independent prediction series:
  |
  | 1d
  | 30d
  | 90d
  |
  |--------------------------------------------------------------------------
  */

  const predictionSeries =
    useMemo<
      PredictionHistoryPoint[]
    >(
      () =>
        forecastSeries
          .filter(
            (point) =>
              point.target_date &&
              Number.isFinite(
                Number(
                  point.predicted_nav,
                ),
              ),
          )
          .map(
            (point) => ({
              date:
                point.target_date,
              value:
                Number(
                  point.predicted_nav,
                ),
            }),
          ),
      [forecastSeries],
    );

  /*
  |--------------------------------------------------------------------------
  | 1 Day predictions
  |--------------------------------------------------------------------------
  */

  const oneDayPredictions =
    useMemo<
      PredictionHistoryPoint[]
    >(
      () =>
        forecastSeries
          .filter(
            (point) =>
              point.horizon === "1d" &&
              point.target_date &&
              Number.isFinite(
                Number(
                  point.predicted_nav,
                ),
              ),
          )
          .map(
            (point) => ({
              date:
                point.target_date,
              value:
                Number(
                  point.predicted_nav,
                ),
            }),
          ),
      [forecastSeries],
    );

  /*
  |--------------------------------------------------------------------------
  | 30 Day predictions
  |--------------------------------------------------------------------------
  */

  const thirtyDayPredictions =
    useMemo<
      PredictionHistoryPoint[]
    >(
      () =>
        forecastSeries
          .filter(
            (point) =>
              point.horizon === "30d" &&
              point.target_date &&
              Number.isFinite(
                Number(
                  point.predicted_nav,
                ),
              ),
          )
          .map(
            (point) => ({
              date:
                point.target_date,
              value:
                Number(
                  point.predicted_nav,
                ),
            }),
          ),
      [forecastSeries],
    );

  /*
  |--------------------------------------------------------------------------
  | 90 Day predictions
  |--------------------------------------------------------------------------
  */

  const ninetyDayPredictions =
    useMemo<
      PredictionHistoryPoint[]
    >(
      () =>
        forecastSeries
          .filter(
            (point) =>
              point.horizon === "90d" &&
              point.target_date &&
              Number.isFinite(
                Number(
                  point.predicted_nav,
                ),
              ),
          )
          .map(
            (point) => ({
              date:
                point.target_date,
              value:
                Number(
                  point.predicted_nav,
                ),
            }),
          ),
      [forecastSeries],
    );

  /*
  |--------------------------------------------------------------------------
  | Render
  |--------------------------------------------------------------------------
  */

  return (
    <AppCard
      style={styles.card}
    >
      <AppText
        variant="heading"
        style={
          styles.sectionTitle
        }
      >
        AI Forecast
      </AppText>

      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={
          false
        }
        contentContainerStyle={
          styles.forecastScroll
        }
      >
        {report.predictions.map(
          (
            prediction: Forecast,
          ) => (
            <ForecastCard
              key={
                prediction.forecast_id
              }
              prediction={
                prediction
              }
              currency={
                currency
              }
            />
          ),
        )}
      </ScrollView>

      <AppText
        variant="heading"
        style={
          styles.chartTitle
        }
      >
        Forecast Chart
      </AppText>

      <ForecastChart
        history={
          historySeries
        }
        oneDayPredictions={
          oneDayPredictions
        }
        thirtyDayPredictions={
          thirtyDayPredictions
        }
        ninetyDayPredictions={
          ninetyDayPredictions
        }
      />
    </AppCard>
  );
}

/*
|--------------------------------------------------------------------------
| Forecast card
|--------------------------------------------------------------------------
*/

function ForecastCard({
  prediction,
  currency,
}: {
  prediction: Forecast;
  currency: string;
}) {
  const horizonLabel =
    getHorizonLabel(
      prediction.horizon,
    );

  const expectedReturn =
    prediction.expected_return_pct !=
    null
      ? Number(
          prediction.expected_return_pct,
        )
      : null;

  /*
  |--------------------------------------------------------------------------
  | Normalize confidence
  |--------------------------------------------------------------------------
  |
  | Backend may return:
  |
  | 0.75
  |
  | or:
  |
  | 75
  |
  |--------------------------------------------------------------------------
  */

  const rawConfidence =
    prediction.confidence_score !=
    null
      ? Number(
          prediction.confidence_score,
        )
      : null;

  const confidence =
    rawConfidence == null
      ? null
      : rawConfidence <= 1
        ? rawConfidence * 100
        : rawConfidence;

  const trend =
    prediction.trend ?? "";

  const recommendation =
    prediction.recommendation ??
    "";

  const returnColor =
    expectedReturn == null
      ? colors.subtitle
      : expectedReturn >= 0
        ? colors.success
        : colors.danger;

  const trendColor =
    trend.toLowerCase() ===
    "bullish"
      ? colors.success
      : trend.toLowerCase() ===
          "bearish"
        ? colors.danger
        : colors.warning;

  const recommendationLower =
    recommendation.toLowerCase();

  const recommendationColor =
    recommendationLower.includes(
      "buy",
    )
      ? colors.success
      : recommendationLower.includes(
            "sell",
          )
        ? colors.danger
        : colors.warning;

  return (
    <View
      style={
        styles.forecastCard
      }
    >
      <View
        style={
          styles.horizonContainer
        }
      >
        <AppText
          variant="body"
          style={styles.horizon}
        >
          {horizonLabel}
        </AppText>
      </View>

      <View
        style={styles.metricBlock}
      >
        <AppText
          variant="caption"
          color={
            colors.subtitle
          }
        >
          Target Date
        </AppText>

        <AppText
          variant="body"
          style={
            styles.metricValue
          }
        >
          {prediction.target_date ??
            "—"}
        </AppText>
      </View>

      <View
        style={styles.metricBlock}
      >
        <AppText
          variant="caption"
          color={
            colors.subtitle
          }
        >
          Predicted NAV
        </AppText>

        <AppText
          variant="body"
          style={
            styles.metricValue
          }
        >
          {prediction.predicted_nav !=
          null
            ? formatCurrency(
                prediction.predicted_nav,
                currency,
              )
            : "—"}
        </AppText>
      </View>

      <View
        style={styles.metricBlock}
      >
        <AppText
          variant="caption"
          color={
            colors.subtitle
          }
        >
          Expected Return
        </AppText>

        <AppText
          variant="body"
          color={
            returnColor
          }
          style={
            styles.metricValue
          }
        >
          {expectedReturn !=
            null &&
          Number.isFinite(
            expectedReturn,
          )
            ? `${
                expectedReturn >=
                0
                  ? "+"
                  : ""
              }${expectedReturn.toFixed(
                2,
              )}%`
            : "—"}
        </AppText>
      </View>

      <View
        style={styles.metricBlock}
      >
        <AppText
          variant="caption"
          color={
            colors.subtitle
          }
        >
          Prediction Confidence
        </AppText>

        <AppText
          variant="body"
          style={
            styles.metricValue
          }
        >
          {confidence !=
            null &&
          Number.isFinite(
            confidence,
          )
            ? `${confidence.toFixed(
                0,
              )}%`
            : "—"}
        </AppText>
      </View>

      <View
        style={styles.metricBlock}
      >
        <AppText
          variant="caption"
          color={
            colors.subtitle
          }
        >
          Market Trend
        </AppText>

        <AppText
          variant="body"
          color={
            trendColor
          }
          style={
            styles.metricValue
          }
        >
          {trend || "—"}
        </AppText>
      </View>

      <View
        style={styles.metricBlock}
      >
        <AppText
          variant="caption"
          color={
            colors.subtitle
          }
        >
          Recommendation
        </AppText>

        <AppText
          variant="body"
          color={
            recommendationColor
          }
          style={
            styles.metricValue
          }
        >
          {recommendation ||
            "—"}
        </AppText>
      </View>
    </View>
  );
}

/*
|--------------------------------------------------------------------------
| Horizon label
|--------------------------------------------------------------------------
*/

function getHorizonLabel(
  horizon:
    | string
    | undefined,
): string {
  switch (
    String(
      horizon,
    ).toLowerCase()
  ) {
    case "1d":
      return "1 Day";

    case "30d":
      return "30 Days";

    case "90d":
      return "90 Days";

    default:
      return (
        horizon ??
        "Forecast"
      );
  }
}

/*
|--------------------------------------------------------------------------
| Styles
|--------------------------------------------------------------------------
*/

const styles =
  StyleSheet.create({
    card: {
      marginBottom:
        spacing.lg,
    },

    sectionTitle: {
      marginBottom:
        spacing.md,
    },

    forecastScroll: {
      gap: spacing.md,
      paddingBottom:
        spacing.sm,
    },

    forecastCard: {
      width: 230,
      padding:
        spacing.md,
      borderRadius: 14,
      backgroundColor:
        colors.background,
      borderWidth: 1,
      borderColor:
        colors.border,
    },

    horizonContainer: {
      marginBottom:
        spacing.md,
      paddingBottom:
        spacing.sm,
      borderBottomWidth:
        StyleSheet.hairlineWidth,
      borderBottomColor:
        colors.border,
    },

    horizon: {
      fontWeight: "700",
      fontSize: 16,
    },

    metricBlock: {
      marginBottom:
        spacing.sm,
    },

    metricValue: {
      marginTop: 2,
      fontWeight: "600",
    },

    chartTitle: {
      marginTop:
        spacing.lg,
      marginBottom:
        spacing.md,
    },

    legendItem: {
      flexDirection:
        "row",
      alignItems:
        "center",
    },

    legendLine: {
      width: 18,
      height: 2,
      marginRight: 5,
    },
  });