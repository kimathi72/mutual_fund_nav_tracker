import React from "react";
import { ScrollView } from "react-native";
import { useLocalSearchParams } from "expo-router";

import AppScreen from "@/components/common/AppScreen";
import LoadingView from "@/components/common/LoadingView";
import {ErrorView} from "@/components/common/ErrorView";
import AppText from "@/components/common/AppText";
import SectionHeader from "@/components/common/SectionHeader";

import NavHistoryChart from "@/components/charts/NavHistoryChart";

import FundHeader from "@/components/fund/FundHeader";
import FundPerformance from "@/components/fund/FundPerformance";
import FundRisk from "@/components/fund/FundRisk";
import FundForecast from "@/components/fund/FundForecast";
import FundInsight from "@/components/fund/FundInsight";

import {useFundDetails} from "@/hooks/useFundDetails";

export default function FundDetailsScreen() {
  const { id } = useLocalSearchParams();

  const {
    data: fund,
    isLoading,
    isError,
    refetch,
  } = useFundDetails(Number(id));

  if (isLoading) {
    return <LoadingView />;
  }

  if (isError) {
    return (
      <ErrorView
        message="Unable to load fund."
        onRetry={() => refetch()}
      />
    );
  }
  console.log(fund)
  if (!fund) {
    return (
      <AppScreen>
        <AppText>Fund not found.</AppText>
      </AppScreen>
    );
  }

  return (
    <AppScreen>
      <ScrollView
        showsVerticalScrollIndicator={false}
      >
        <SectionHeader
          title={fund.performance.fund_name}
          subtitle={fund.performance.isin}
        />

        <FundHeader
          name={fund.performance.fund_name}
          isin={fund.performance.isin}
          nav={fund.performance.latest_nav}
          currency={fund.performance.currency}
          navDate={fund.performance.nav_date}
        />

        <NavHistoryChart
          history={fund.nav_history}
        />

        <FundPerformance
          performance={fund.performance}
        />

        <FundRisk
          risk={fund.risk}
          history={fund.volatility_history}
        />

        <FundForecast
          report={fund.forecast}
          history={fund.nav_history}
          forecastSeries={fund.forecast_series}
        />

        <FundInsight
          insight={
            fund.executive_insight
          }
        />
      </ScrollView>
    </AppScreen>
  );
}