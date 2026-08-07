import React from "react";
import { ScrollView } from "react-native";

import AppScreen from "@/components/common/AppScreen";
import LoadingView from "@/components/common/LoadingView";
import { ErrorView } from "@/components/common/ErrorView";

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

  return (
    <AppScreen>
      <ScrollView
        showsVerticalScrollIndicator={false}
      >
        <FundHeader
          fund={fund}
        />

     

        <FundPerformance
          fund={fund}
          history={fund.history?.nav ?? []}
        />

        <FundRisk
          risk={fund.risk}
          history={fund.history?.volatility ?? []}
        />

        <FundForecast
          report={fund.forecast}
          history={fund.history?.nav ?? []}
          forecastSeries={
            fund.history?.prediction_history ?? []
          }
        />
      </ScrollView>
    </AppScreen>
  );
}