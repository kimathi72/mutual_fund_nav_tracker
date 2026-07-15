import React from "react";

import {
  ScrollView,
  StyleSheet,
} from "react-native";

import { useLocalSearchParams } from "expo-router";

import AppScreen from "@/components/common/AppScreen";
import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";
import SectionHeader from "@/components/common/SectionHeader";

import { useDashboard } from "@/hooks/useDashboard";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

import formatCurrency from "@/utils/formatCurrency";
import formatPercentage from "@/utils/formatPercentage";
import riskColor from "@/utils/riskColor";

export default function FundDetailsScreen() {
  const { id } = useLocalSearchParams();

  const { data, isLoading } = useDashboard();

  if (isLoading || !data) {
    return <AppScreen />;
  }

  const fund = data.funds.find(
    (f) => f.performance.fund_id === Number(id)
  );

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

        <AppCard>
          <AppText variant="caption">
            Latest NAV
          </AppText>

          <AppText size={30} weight="bold">
            {formatCurrency(
              fund.performance.latest_nav,
              fund.performance.currency
            )}
          </AppText>
        </AppCard>

        <AppCard style={styles.card}>
          <AppText weight="bold">
            Performance
          </AppText>

          <AppText>
            Daily: {formatPercentage(fund.performance.daily_return)}
          </AppText>

          <AppText>
            Weekly: {formatPercentage(fund.performance.weekly_return)}
          </AppText>

          <AppText>
            Monthly: {formatPercentage(fund.performance.monthly_return)}
          </AppText>

          <AppText>
            YTD: {formatPercentage(fund.performance.ytd_return)}
          </AppText>
        </AppCard>

        <AppCard style={styles.card}>
          <AppText weight="bold">
            Risk
          </AppText>

          <AppText
            style={{
              color: riskColor(fund.risk.volatility),
            }}
          >
            Volatility: {formatPercentage(fund.risk.volatility)}
          </AppText>

          <AppText>
            Drawdown: {formatPercentage(fund.risk.drawdown)}
          </AppText>
        </AppCard>

        <AppCard style={styles.card}>
          <AppText weight="bold">
            Forecast
          </AppText>

          <AppText>
            Trend: {fund.forecast.trend}
          </AppText>

          <AppText>
            Predicted NAV:{" "}
            {formatCurrency(
              fund.forecast.predicted_nav,
              fund.performance.currency
            )}
          </AppText>

          <AppText>
            Confidence:{" "}
            {Math.round(fund.executive_insight.confidence * 100)}%
          </AppText>
        </AppCard>

        <AppCard style={styles.card}>
          <AppText weight="bold">
            AI Executive Insight
          </AppText>

          <AppText>
            {fund.executive_insight.summary}
          </AppText>
        </AppCard>
      </ScrollView>
    </AppScreen>
  );
}

const styles = StyleSheet.create({
  card: {
    marginTop: spacing.lg,
  },
});