import { StyleSheet, View } from "react-native";

import { PortfolioInsight } from "@/models/PortfolioInsight";

import  AppCard  from "@/components/common/AppCard";
import  AppText  from "@/components/common/AppText";

import  colors  from "@/constants/colors";
import  spacing  from "@/constants/spacing";

type Props = {
  insight: PortfolioInsight;
};

export default function PortfolioHealthCard({
  insight,
}: Props) {
  return (
    <AppCard>

      <AppText
        size={20}
        weight="bold"
      >
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
        style={styles.caption}
      >
        Executive Recommendation
      </AppText>

      <AppText style={styles.recommendation}>
        {insight.executive_recommendation}
      </AppText>

    </AppCard>
  );
}

type BadgeProps = {
  label: string;
  value: string;
};

function StatusBadge({
  label,
  value,
}: BadgeProps) {
  return (
    <View style={styles.badge}>
      <AppText variant="caption">
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
          style={styles.pillText}
        >
          {value}
        </AppText>
      </View>
    </View>
  );
}

function badgeColor(value: string) {
  switch (value.toLowerCase()) {
    case "strong":
    case "bullish":
    case "low":
      return colors.success;

    case "moderate":
    case "neutral":
    case "medium":
      return colors.warning;

    case "weak":
    case "bearish":
    case "high":
      return colors.danger;

    default:
      return colors.border;
  }
}

const styles = StyleSheet.create({

  badges: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginTop: spacing.lg,
  },

  badge: {
    alignItems: "center",
    flex: 1,
  },

  pill: {
    marginTop: spacing.sm,
    borderRadius: 20,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
    minWidth: 70,
    alignItems: "center",
  },

  pillText: {
    color: "#FFF",
    fontWeight: "700",
  },

  divider: {
    height: 1,
    backgroundColor: colors.border,
    marginVertical: spacing.xl,
  },

  caption: {
    color: colors.subtitle,
    marginBottom: spacing.sm,
  },

  recommendation: {
    lineHeight: 24,
  },

});