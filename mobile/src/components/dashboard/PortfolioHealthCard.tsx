import React from "react";
import { StyleSheet, View } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

import type { PortfolioInsight } from "@/models/PortfolioInsight";

interface Props {
  insight: PortfolioInsight;
}

export default function PortfolioHealthCard({
  insight,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <AppText variant="heading">
        Portfolio Health
      </AppText>

      <View style={styles.badges}>
        <StatusBadge
          label="Health"
          value={insight.portfolio_health}
        />

        <StatusBadge
          label="Sentiment"
          value={insight.market_sentiment}
        />

        <StatusBadge
          label="Risk"
          value={insight.portfolio_risk}
        />
      </View>

      <View style={styles.divider} />

      <AppText
        variant="caption"
        color={colors.subtitle}
      >
        Executive Recommendation
      </AppText>

      <AppText
        variant="body"
        style={styles.recommendation}
      >
        {insight.executive_recommendation}
      </AppText>
    </AppCard>
  );
}

interface BadgeProps {
  label: string;
  value: string;
}

function StatusBadge({
  label,
  value,
}: BadgeProps) {
  return (
    <View style={styles.badge}>
      <AppText
        variant="caption"
        color={colors.subtitle}
      >
        {label}
      </AppText>

      <View
        style={[
          styles.pill,
          {
            backgroundColor: badgeColor(value),
          },
        ]}
      >
        <AppText
          variant="caption"
          color="#FFF"
        >
          {value}
        </AppText>
      </View>
    </View>
  );
}

function badgeColor(value: string) {
  const normalized =
    value.trim().toLowerCase();

  switch (normalized) {
    case "excellent":
    case "healthy":
    case "bullish":
    case "positive":
    case "low":
    case "strong":
      return colors.success;

    case "stable":
    case "moderate":
    case "neutral":
    case "medium":
      return colors.warning;

    case "poor":
    case "weak":
    case "bearish":
    case "negative":
    case "high":
      return colors.danger;

    default:
      return colors.border;
  }
}

const styles = StyleSheet.create({
  card: {
    marginHorizontal: spacing.md,
    marginBottom: spacing.md,
  },

  badges: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginTop: spacing.lg,
  },

  badge: {
    flex: 1,
    alignItems: "center",
  },

  pill: {
    marginTop: spacing.sm,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
    borderRadius: 20,
    minWidth: 85,
    alignItems: "center",
  },

  divider: {
    height: 1,
    backgroundColor: colors.border,
    marginVertical: spacing.lg,
  },

  recommendation: {
    marginTop: spacing.sm,
    lineHeight: 22,
  },
});