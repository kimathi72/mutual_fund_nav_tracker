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
  Forecast,
} from "@/models/Forecast";
import { ForecastPoint, TimeSeriesPoint } from "../charts/types";

interface Props {
  report: ForecastReport;

  history: TimeSeriesPoint[];

  forecastSeries: ForecastPoint[];
}

export default function FundForecast({
  report,
  history,
  forecastSeries,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <AppText variant="heading">
        AI Forecast
      </AppText>

      {report.forecasts.map((forecast: Forecast) => (
        <ForecastRow
          key={`${forecast.horizon}-${forecast.target_date}`}
          forecast={forecast}
          currency="USD"
        />
      ))}

      <ForecastChart
        history={history}
        forecast={forecastSeries}
      />
    </AppCard>
  );
}

function ForecastRow({
  forecast,
  currency,
}: {
  forecast: Forecast;
  currency: string;
}) {
  return (
    <>
      <AppText>
        {forecast.horizon.toUpperCase()}
      </AppText>

      <AppText>
        NAV{" "}
        {formatCurrency(
          forecast.predicted_nav ?? 0,
          currency
        )}
      </AppText>

      <AppText>
        Return{" "}
        {formatPercentage(
          forecast.expected_return_pct ?? 0
        )}
      </AppText>

      <AppText>
        Confidence{" "}
        {Math.round(
          (forecast.confidence_score ?? 0) *
            100
        )}
        %
      </AppText>

      <AppText>
        {forecast.recommendation}
      </AppText>

      <AppText>
        {forecast.trend}
      </AppText>

      <AppText>{"----------------"}</AppText>
    </>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.lg,
  },
});