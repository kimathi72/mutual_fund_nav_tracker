
// screens/FundDetailsScreen.tsx

import React from "react";
import { ScrollView } from "react-native";

import AppScreen from "@/components/common/AppScreen";
import LoadingView from "@/components/common/LoadingView";
import ErrorView from "@/components/common/ErrorView";

import FundHeader from "@/components/fund/FundHeader";
import FundPerformance from "@/components/fund/FundPerformance";
import FundRisk from "@/components/fund/FundRisk";
import FundForecast from "@/components/fund/FundForecast";

import { useFundDetails } from "@/hooks/useFundDetails";

export default function FundDetailsScreen({
  id,
}: {
  id: number;
}) {
  const {
    data: fund,
    isLoading,
    error,
  } = useFundDetails(id);

  if (isLoading) {
    return <LoadingView />;
  }

  console.log("Fund:", fund);
  console.log("Query error:", error);

  if (error || !fund) {
    return (
      <ErrorView
        message={
          error instanceof Error
            ? error.message
            : JSON.stringify(error)
        }
      />
    );
  }
  console.log("========== FUND CURRENCY DEBUG ==========");
console.log("Fund ID:", id);
console.log("Fund name:", fund?.name);
console.log("Fund currency:", fund?.currency);
console.log("Fund NAV:", fund?.nav);
console.log("Performance:", fund?.performance);
console.log("Latest NAV:", fund?.performance?.latest_nav);
console.log("========================================");

  return (
    <AppScreen>
      <ScrollView showsVerticalScrollIndicator={false}>
        <FundHeader fund={fund} />

        <FundPerformance
          fund={fund}
          history={fund.history.nav}
        />

        <FundRisk
          risk={fund.risk}
          history={fund.history.volatility}
          executiveInsight={fund.executive_insight}
        />

        <FundForecast
          report={fund.forecast}
          history={fund.history.nav}
          forecastSeries={fund.history.prediction_history}
          currency={fund.performance.currency}
        />
      </ScrollView>
    </AppScreen>
  );
}
