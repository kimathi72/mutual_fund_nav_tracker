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

import NavHistoryChart from "@/components/charts/NavHistoryChart";
import VolatilityChart from "@/components/charts/VolatilityChart";
import RiskHeatMap from "@/components/charts/RiskHeatMap";

import { useDashboard } from "@/hooks/useDashboard";

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
        <AppText>
          Fund not found.
        </AppText>
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

        {/* NAV */}

        <AppCard>
          <AppText variant="caption">
            Latest NAV
          </AppText>

          <AppText
            variant="title"
          >
            {formatCurrency(
              fund.performance.latest_nav,
              fund.performance.currency
            )}
          </AppText>
        </AppCard>

        {/* NAV History */}

        <AppCard style={styles.card}>
          <AppText variant="heading">
            NAV History
          </AppText>

          <NavHistoryChart
            history={fund.nav_history}
          />
        </AppCard>

        {/* Performance */}

        <AppCard style={styles.card}>
          <AppText variant="heading">
            Performance
          </AppText>

          <AppText>
            Daily:{" "}
            {formatPercentage(
              fund.performance.daily_return
            )}
          </AppText>

          <AppText>
            Weekly:{" "}
            {formatPercentage(
              fund.performance.weekly_return
            )}
          </AppText>

          <AppText>
            Monthly:{" "}
            {formatPercentage(
              fund.performance.monthly_return
            )}
          </AppText>

          <AppText>
            YTD:{" "}
            {formatPercentage(
              fund.performance.ytd_return
            )}
          </AppText>
        </AppCard>

        {/* Risk */}

        <AppCard style={styles.card}>
          <AppText variant="heading">
            Risk Analysis
          </AppText>

          <AppText
            style={{
              color: riskColor(
                fund.risk.volatility
              ),
            }}
          >
            Volatility:{" "}
            {formatPercentage(
              fund.risk.volatility
            )}
          </AppText>

          <AppText>
            Drawdown:{" "}
            {formatPercentage(
              fund.risk.drawdown
            )}
          </AppText>

          <VolatilityChart
            history={fund.volatility_history}
          />

          <RiskHeatMap
            value={fund.risk.volatility}
          />
        </AppCard>

        {/* Forecast */}

        <AppCard style={styles.card}>
          <AppText variant="heading">
            AI Forecast
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
            {Math.round(
              fund.executive_insight.confidence * 100
            )}
            %
          </AppText>

          <NavHistoryChart
            history={fund.forecast_series}
          />
        </AppCard>

        {/* Executive Insight */}

        <AppCard style={styles.card}>
          <AppText variant="heading">
            Executive Insight
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