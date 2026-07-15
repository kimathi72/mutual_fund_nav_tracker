import React from "react";
import { Pressable, StyleSheet, View } from "react-native";

import { useRouter } from "expo-router";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

import ExecutiveFund from "@/models/ExecutiveFund";

import formatCurrency from "@/utils/formatCurrency";
import formatPercentage from "@/utils/formatPercentage";
import riskColor from "@/utils/riskColor";

type Props = {
  fund: ExecutiveFund;
};

export default function FundCard({
  fund,
}: Props) {
  const router = useRouter();

  const performance = fund.performance;
  const risk = fund.risk;
  const forecast = fund.forecast;

  return (
    <Pressable
      onPress={() =>
        router.push(`/fund/${performance.fund_id}`)
      }
    >
      <AppCard style={styles.card}>
        <View style={styles.header}>
          <View style={{ flex: 1 }}>
            <AppText variant="subheading">
              {performance.fund_name}
            </AppText>

            <AppText
              variant="caption"
              color={colors.subtitle}
            >
              {performance.isin}
            </AppText>
          </View>

          <View
            style={[
              styles.badge,
              {
                backgroundColor:
                  riskColor(
                    fund.executive_insight.risk_level
                  ),
              },
            ]}
          >
            <AppText
              variant="caption"
              color="#fff"
            >
              {fund.executive_insight.risk_level}
            </AppText>
          </View>
        </View>

        <View style={styles.metrics}>
          <Metric
            label="NAV"
            value={formatCurrency(
              performance.latest_nav,
              performance.currency
            )}
          />

          <Metric
            label="YTD"
            value={formatPercentage(
              performance.ytd_return
            )}
          />

          <Metric
            label="Forecast"
            value={formatCurrency(
              forecast.predicted_nav,
              performance.currency
            )}
          />
        </View>

        <View style={styles.footer}>
          <AppText
            variant="caption"
            color={colors.subtitle}
          >
            {fund.executive_insight.recommendation}
          </AppText>
        </View>
      </AppCard>
    </Pressable>
  );
}

type MetricProps = {
  label: string;
  value: string;
};

function Metric({
  label,
  value,
}: MetricProps) {
  return (
    <View style={styles.metric}>
      <AppText
        variant="caption"
        color={colors.subtitle}
      >
        {label}
      </AppText>

      <AppText variant="body">
        {value}
      </AppText>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    width: 330,
    marginRight: spacing.md,
  },

  header: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "flex-start",
  },

  badge: {
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: 20,
  },

  metrics: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginTop: spacing.lg,
  },

  metric: {
    alignItems: "center",
  },

  footer: {
    marginTop: spacing.lg,
  },
});