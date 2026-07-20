import React from "react";
import { ScrollView } from "react-native";
import { useLocalSearchParams } from "expo-router";

import AppScreen from "@/components/common/AppScreen";
import LoadingView from "@/components/common/LoadingView";
import AppText from "@/components/common/AppText";
import SectionHeader from "@/components/common/SectionHeader";

import NavHistoryChart from "@/components/charts/NavHistoryChart";

import FundHeader from "@/components/fund/FundHeader";
import FundPerformance from "@/components/fund/FundPerformance";
import FundRisk from "@/components/fund/FundRisk";
import FundForecast from "@/components/fund/FundForecast";
import FundInsight from "@/components/fund/FundInsight";

import useFundDetails from "@/hooks/useFundDetails";

export default function FundDetailsScreen() {
  const { id } = useLocalSearchParams();

  const {
    data: fund,
    isLoading,
  } = useFundDetails(Number(id));

  if (isLoading) {
    return <LoadingView />;
  }

  if (!fund) {
    return (
      <AppScreen>
        <AppText>Fund not found.</AppText>
      </AppScreen>
    );
  }

  return (
    <AppScreen>
      <ScrollView showsVerticalScrollIndicator={false}>
        <SectionHeader
          title={fund.performance.fund_name}
          subtitle={fund.performance.isin}
        />

        <FundHeader
          name={fund.performance.fund_name}
          isin={fund.performance.isin}
          nav={fund.performance.latest_nav}
          currency={fund.performance.currency}
        />

        <NavHistoryChart
          history={fund.nav_history}
        />

        <FundPerformance
          daily={fund.performance.daily_return}
          weekly={fund.performance.weekly_return}
          monthly={fund.performance.monthly_return}
          ytd={fund.performance.ytd_return}
        />

        <FundRisk
          volatility_30={fund.risk.volatility_30}
          drawdown={fund.risk.drawdown}
          ytdReturn={fund.performance.ytd_return}
          history={fund.volatility_history}
        />

        <FundForecast
          history={fund.nav_history}
          forecast={fund.forecast_series}
          trend={fund.forecast.trend}
          predictedNav={fund.forecast.predicted_nav}
          confidence={fund.forecast.confidence ?? 0}
          currency={fund.performance.currency}
        />

        <FundInsight
          summary={
            fund.executive_insight.executive_summary
          }
        />
      </ScrollView>
    </AppScreen>
  );
}