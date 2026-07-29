import React from "react";
import { StyleSheet } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import ForecastChart from "@/components/charts/ForecastChart";

import spacing from "@/constants/spacing";

import formatCurrency from "@/utils/formatCurrency";
import formatPercentage from "@/utils/formatPercentage";

import {
  ForecastReport,
  Prediction,
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
}

export default function FundForecast({
  report,
  history,
  forecastSeries,
}: Props) {
  const historySeries: TimeSeriesPoint[] = history.map(
    (point) => ({
      date: point.date,
      value: Number(point.nav),
    })
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
      <AppText variant="heading">
        AI Forecast
      </AppText>

      {report.predictions.map(
        (prediction: Prediction) => (
          <ForecastRow
            key={`${prediction.horizon}-${prediction.target_date}`}
            prediction={prediction}
            currency="USD"
          />
        )
      )}

      <ForecastChart
        history={historySeries}
        forecast={predictionSeries}
      />
    </AppCard>
  );
}

function ForecastRow({
  prediction,
  currency,
}: {
  prediction: Prediction;
  currency: string;
}) {
  return (
    <>
      <AppText>
        {prediction.horizon.toUpperCase()}
      </AppText>

      <AppText>
        NAV{" "}
        {formatCurrency(
          prediction.predicted_nav ?? 0,
          currency
        )}
      </AppText>

      <AppText>
        Return{" "}
        {formatPercentage(
          prediction.expected_return_pct ?? 0
        )}
      </AppText>

      <AppText>
        Confidence{" "}
        {Math.round(
          (prediction.confidence_score ?? 0) * 100
        )}
        %
      </AppText>

      <AppText>
        {prediction.recommendation}
      </AppText>

      <AppText>
        {prediction.trend}
      </AppText>

      <AppText>
        ----------------
      </AppText>
    </>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.lg,
  },
});