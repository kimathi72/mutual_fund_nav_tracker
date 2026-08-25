import React from "react";
import { Pressable, StyleSheet, View } from "react-native";

import { useRouter } from "expo-router";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

import type { FundSummary } from "@/models/FundSummary";

import formatCurrency from "@/utils/formatCurrency";
import formatPercentage from "@/utils/formatPercentage";

interface Props {
  fund: FundSummary;
}

export default function FundCard({
  fund,
}: Props) {
  const router = useRouter();

  const volatility =
    Number(fund.volatility) * 100;

  const riskLevel =
    volatility >= 35
      ? "High"
      : volatility >= 15
      ? "Medium"
      : "Low";

  const badgeColor =
    riskLevel === "High"
      ? colors.danger
      : riskLevel === "Medium"
      ? colors.warning
      : colors.success;

  return (
    <Pressable
      onPress={() =>
        router.push(`/fund/${fund.id}`)
      }
    >
      <AppCard style={styles.card}>
        <View style={styles.header}>
          <View style={{ flex: 1 }}>
            <AppText variant="heading">
              {fund.name}
            </AppText>

            <AppText
              variant="caption"
              color={colors.subtitle}
            >
              {fund.isin}
            </AppText>
          </View>

          <View
            style={[
              styles.badge,
              {
                backgroundColor: badgeColor,
              },
            ]}
          >
            <AppText
              variant="caption"
              color="#fff"
            >
              {riskLevel}
            </AppText>
          </View>
        </View>

        <View style={styles.metrics}>
          <Metric
            label="NAV"
            value={formatCurrency(
              Number(fund.nav),
              fund.currency
            )}
          />

          <Metric
            label="YTD"
            value={formatPercentage(
              Number(fund.ytd_return)
            )}
            valueColor={Number(fund.ytd_return) >= 0 ? colors.success : colors.danger}
          />

          <Metric
            label="Volatility"
            value={`${volatility.toFixed(1)}%`}
          />
        </View>

        <View style={styles.footer}>
          <AppText
            variant="caption"
            color={colors.subtitle}
          >
            {fund.recommendation}
          </AppText>

          <AppText
            variant="caption"
            color={colors.primary}
          >
            {fund.market_outlook}
          </AppText>
        </View>
      </AppCard>
    </Pressable>
  );
}

interface MetricProps {
  label: string;
  value: string;
  valueColor?: string;
}

function Metric({
  label,
  value,
  valueColor,
}: MetricProps) {
  return (
    <View style={styles.metric}>
      <AppText
        variant="caption"
        color={colors.subtitle}
      >
        {label}
      </AppText>

      <AppText variant="body"
        style={[valueColor ? { color: valueColor } : undefined]}
      >
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
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
});