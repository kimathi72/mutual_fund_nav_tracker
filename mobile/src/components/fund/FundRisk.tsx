
import React from "react";
import { StyleSheet, View } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import {
  VolatilityChart,
} from "@/components/charts";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

import riskColor from "@/utils/riskColor";
import formatPercentage from "@/utils/formatPercentage";

import { RiskReport } from "@/models/RiskReport";
import { VolatilityPoint } from "@/models/VolatilityPoint";
import { ExecutiveInsight } from "@/models/ExecutiveFund";

interface Props {
  risk: RiskReport;
  history: VolatilityPoint[];
  executiveInsight?: ExecutiveInsight | null;
}

export default function FundRisk({
  risk,
  history,
  executiveInsight,
}: Props) {
  const riskLevel = String(
    risk.risk_level ?? "Unknown",
  );

  const riskLevelColor = riskColor(riskLevel);

  const insightRecommendation = String(
    executiveInsight?.recommendation ?? "—",
  );

  const marketOutlook = String(
    executiveInsight?.market_outlook ?? "—",
  );

  const confidence = String(
    executiveInsight?.confidence ?? "—",
  );

  const opportunityScore =
    executiveInsight?.opportunity_score;

  const outlookColor =
    marketOutlook.toLowerCase() === "bullish"
      ? colors.success
      : marketOutlook.toLowerCase() === "bearish"
        ? colors.danger
        : colors.warning;

  const recommendationColor =
    insightRecommendation.toLowerCase().includes("buy")
      ? colors.success
      : insightRecommendation.toLowerCase().includes("sell")
        ? colors.danger
        : colors.warning;

  return (
    <AppCard style={styles.card}>
      {/* Header */}
      <View style={styles.header}>
        <View style={styles.headerText}>
          <AppText
            variant="title"
            style={styles.title}
          >
            Risk Analysis
          </AppText>

          <AppText
            variant="caption"
            color={colors.subtitle}
            style={styles.subtitle}
          >
            Portfolio risk and volatility
          </AppText>
        </View>

        {/* Risk badge */}
        <View
          style={[
            styles.riskBadge,
            {
              backgroundColor: `${riskLevelColor}18`,
              borderColor: `${riskLevelColor}45`,
            },
          ]}
        >
          <View
            style={[
              styles.riskDot,
              {
                backgroundColor: riskLevelColor,
              },
            ]}
          />

          <AppText
            variant="caption"
            style={[
              styles.riskBadgeText,
              {
                color: riskLevelColor,
              },
            ]}
          >
            {riskLevel}
          </AppText>
        </View>
      </View>

      {/* Risk Metrics */}
      <View style={styles.metricsRow}>
        <RiskMetric
          label="Volatility"
          value={formatPercentage(
            risk.volatility_30,
          )}
        />

        <View style={styles.divider} />

        <RiskMetric
          label="Max Drawdown"
          value={formatPercentage(
            risk.drawdown,
          )}
        />
      </View>

      {/* Volatility Chart */}
      <View style={styles.chartSection}>
        <View style={styles.chartHeader}>
          <AppText
            variant="body"
            style={styles.chartTitle}
          >
            Volatility Trend
          </AppText>
        </View>

        {/* Executive Insight */}
        {executiveInsight && (
          <View style={styles.insight}>
            <View style={styles.insightHeader}>
              <View style={styles.insightTitleRow}>
                <View style={styles.insightIndicator} />

                <AppText
                  variant="body"
                  style={styles.insightTitle}
                >
                  Executive Insight
                </AppText>
              </View>

              {executiveInsight.generated_at && (
                <AppText
                  variant="caption"
                  color={colors.subtitle}
                >
                  AI analysis
                </AppText>
              )}
            </View>

            {executiveInsight.executive_summary && (
              <AppText
                variant="caption"
                color={colors.subtitle}
                style={styles.insightSummary}
              >
                {executiveInsight.executive_summary}
              </AppText>
            )}

            <View style={styles.insightMetrics}>
              <InsightMetric
                label="Outlook"
                value={marketOutlook}
                color={outlookColor}
              />

              <InsightMetric
                label="Recommendation"
                value={insightRecommendation}
                color={recommendationColor}
              />

              <InsightMetric
                label="Confidence"
                value={confidence}
                color={colors.primary}
              />

              {opportunityScore !== undefined && (
                <InsightMetric
                  label="Opportunity"
                  value={`${opportunityScore}/100`}
                  color={colors.primary}
                />
              )}
            </View>
          </View>
        )}

        <VolatilityChart
          history={history ?? []}
        />
      </View>
    </AppCard>
  );
}

function RiskMetric({
  label,
  value,
}: {
  label: string;
  value: string;
}) {
  return (
    <View style={styles.metric}>
      <AppText
        variant="caption"
        color={colors.subtitle}
        style={styles.metricLabel}
      >
        {label}
      </AppText>

      <AppText
        variant="heading"
        style={styles.metricValue}
      >
        {value}
      </AppText>
    </View>
  );
}

function InsightMetric({
  label,
  value,
  color,
}: {
  label: string;
  value: string;
  color: string;
}) {
  return (
    <View style={styles.insightMetric}>
      <AppText
        variant="caption"
        color={colors.subtitle}
        style={styles.insightMetricLabel}
      >
        {label}
      </AppText>

      <AppText
        variant="caption"
        style={[
          styles.insightMetricValue,
          { color },
        ]}
      >
        {value}
      </AppText>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.lg,
    padding: spacing.lg,
  },

  header: {
    flexDirection: "row",
    alignItems: "flex-start",
    justifyContent: "space-between",
  },

  headerText: {
    flex: 1,
    marginRight: spacing.md,
  },

  title: {
    fontSize: 20,
    fontWeight: "700",
  },

  subtitle: {
    marginTop: 3,
  },

  riskBadge: {
    flexDirection: "row",
    alignItems: "center",
    borderWidth: 1,
    borderRadius: 999,
    paddingHorizontal: 10,
    paddingVertical: 6,
  },

  riskDot: {
    width: 7,
    height: 7,
    borderRadius: 999,
    marginRight: 6,
  },

  riskBadgeText: {
    fontWeight: "700",
    textTransform: "capitalize",
  },

  metricsRow: {
    flexDirection: "row",
    alignItems: "center",
    marginTop: spacing.lg,
    paddingVertical: spacing.md,
    borderTopWidth: StyleSheet.hairlineWidth,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderTopColor: "#E2E8F0",
    borderBottomColor: "#E2E8F0",
  },

  metric: {
    flex: 1,
    alignItems: "center",
  },

  metricLabel: {
    marginBottom: 4,
    textAlign: "center",
  },

  metricValue: {
    fontSize: 21,
    fontWeight: "700",
    textAlign: "center",
  },

  divider: {
    width: StyleSheet.hairlineWidth,
    height: 38,
    backgroundColor: "#E2E8F0",
  },

  chartSection: {
    marginTop: spacing.lg,
  },

  chartHeader: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    marginBottom: spacing.sm,
  },

  chartTitle: {
    fontWeight: "700",
  },

  insight: {
    marginBottom: spacing.md,
    padding: spacing.md,
    borderRadius: 12,
    backgroundColor: "#F8FAFC",
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: "#E2E8F0",
  },

  insightHeader: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
  },

  insightTitleRow: {
    flexDirection: "row",
    alignItems: "center",
  },

  insightIndicator: {
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: colors.primary,
    marginRight: 7,
  },

  insightTitle: {
    fontWeight: "700",
  },

  insightSummary: {
    marginTop: spacing.sm,
    lineHeight: 18,
  },

  insightMetrics: {
    flexDirection: "row",
    flexWrap: "wrap",
    marginTop: spacing.md,
    paddingTop: spacing.sm,
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: "#E2E8F0",
  },

  insightMetric: {
    width: "50%",
    marginBottom: spacing.sm,
  },

  insightMetricLabel: {
    marginBottom: 2,
  },

  insightMetricValue: {
    fontWeight: "700",
  },
});
