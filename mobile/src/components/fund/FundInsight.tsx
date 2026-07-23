import React from "react";
import { StyleSheet, View } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

import { ExecutiveInsight } from "@/models/ExecutiveInsight";

interface Props {
  insight: ExecutiveInsight;
}

export default function FundInsight({
  insight,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <AppText variant="heading">
        AI Executive Insight
      </AppText>

      <View style={styles.section}>
        <SectionTitle title="Executive Summary" />

        <AppText style={styles.body}>
          {insight.executive_summary}
        </AppText>
      </View>

      <Divider />

      <InfoRow
        label="Recommendation"
        value={insight.recommendation}
      />

      <InfoRow
        label="Market Outlook"
        value={insight.market_outlook}
      />

      <InfoRow
        label="Risk Level"
        value={insight.risk_level}
      />

      <InfoRow
        label="Confidence"
        value={`${Number(
          insight.confidence
        ).toFixed(1)}%`}
      />

      <View style={styles.scoreContainer}>
        <AppText
          variant="caption"
          color={colors.subtitle}
        >
          Opportunity Score
        </AppText>

        <View style={styles.progressBackground}>
          <View
            style={[
              styles.progressFill,
              {
                width: `${Math.min(
                  insight.opportunity_score,
                  100
                )}%`,
              },
            ]}
          />
        </View>

        <AppText
          style={styles.score}
        >
          {insight.opportunity_score}/100
        </AppText>
      </View>

      <AppText
        variant="caption"
        color={colors.subtitle}
        style={styles.generated}
      >
        Generated {new Date(
          insight.generated_at
        ).toLocaleString()}
      </AppText>
    </AppCard>
  );
}

function Divider() {
  return <View style={styles.divider} />;
}

function SectionTitle({
  title,
}: {
  title: string;
}) {
  return (
    <AppText
      variant="caption"
      color={colors.subtitle}
    >
      {title}
    </AppText>
  );
}

function InfoRow({
  label,
  value,
}: {
  label: string;
  value: string;
}) {
  return (
    <View style={styles.row}>
      <AppText
        variant="caption"
        color={colors.subtitle}
      >
        {label}
      </AppText>

      <AppText>{value}</AppText>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.xl,
  },

  section: {
    marginTop: spacing.md,
  },

  body: {
    marginTop: spacing.sm,
    lineHeight: 24,
  },

  divider: {
    height: 1,
    backgroundColor: colors.border,
    marginVertical: spacing.lg,
  },

  row: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: spacing.md,
  },

  scoreContainer: {
    marginTop: spacing.lg,
  },

  progressBackground: {
    height: 10,
    borderRadius: 5,
    backgroundColor: colors.border,
    overflow: "hidden",
    marginVertical: spacing.sm,
  },

  progressFill: {
    height: "100%",
    backgroundColor: colors.primary,
  },

  score: {
    fontWeight: "700",
  },

  generated: {
    marginTop: spacing.xl,
  },
});