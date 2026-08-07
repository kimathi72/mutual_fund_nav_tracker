import React from "react";
import { StyleSheet, View } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import ForecastChart from "@/components/charts/ForecastChart";

import spacing from "@/constants/spacing";

import formatCurrency from "@/utils/formatCurrency";
import formatPercentage from "@/utils/formatPercentage";

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
      <View style={{ display: "flex", flexDirection: "row", justifyContent: "space-between", margin: spacing.md }}>

      {report.predictions.map(
        (prediction: Forecast) => (
          <ForecastRow
            key={`${prediction.horizon}-${prediction.target_date}`}
            prediction={prediction}
            currency="USD"
          />
        )
      )}
      </View>

      <AppText variant="heading">
        Forecast Chart
      </AppText>

      <AppText>
        The chart below shows the historical NAV along with the AI forecasted NAV and confidence intervals.
      </AppText>

      <AppText>
        The shaded area represents the confidence interval, indicating the range within which the actual NAV is expected to fall with a certain level of confidence.
      </AppText>

      <AppText>
        Please note that these forecasts are based on historical data and AI predictions, and actual performance may vary.
      </AppText>

      <AppText>
        Always consider multiple factors and consult with a financial advisor before making investment decisions.
      </AppText>

      <AppText>
        The AI forecast is generated using advanced machine learning algorithms that analyze historical trends and patterns in the fund's performance.
      </AppText>

      <AppText>
        It is important to remember that while AI can provide valuable insights, it cannot predict future market conditions with absolute certainty. Investors should use this information as one of many tools in their decision-making process.
      </AppText>
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
  prediction: Forecast;
  currency: string;
}) {
  return (
    <View style= {{display: "flex", flexDirection: "column", gap: 4, alignItems: "center", justifyContent: "center"}}>
      <AppText>
        {prediction.horizon.toUpperCase()}
      </AppText>

      <AppText>
        Predicted NAV{" "}
        {formatCurrency(
          prediction.predicted_nav ?? 0,
          currency
        )}
      </AppText>

      <AppText>
        Expected Return{"  "}
        {formatPercentage(
          prediction.expected_return_pct ?? 0
        )}
      </AppText>

      <AppText>
        Prediction Confidence{"   "}
        {Math.round(
          (prediction.confidence_score ?? 0) * 100
        )}
        %
      </AppText>
      <AppText>
        Market Trend{"   "}
        {prediction.trend}
      </AppText>

      <AppText>
        Recommendation{"   "}
        {prediction.recommendation}
      </AppText>


    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.lg,
  },
});