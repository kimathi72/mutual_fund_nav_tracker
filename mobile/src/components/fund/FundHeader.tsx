import React from "react";
import { StyleSheet, View } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

import formatCurrency from "@/utils/formatCurrency";
import formatDate from "@/utils/formatDate";
import formatPercentage from "@/utils/formatPercentage";

import { ExecutiveFund } from "@/models/ExecutiveFund";

interface Props {
  fund: ExecutiveFund;
}

export default function FundHeader({ fund }: Props) {
  const performance = fund.performance;
  const currency = performance.currency ?? fund.currency ?? "USD";

  const latestNav =
    performance.latest_nav ?? fund.nav;

  return (
    <AppCard style={styles.card}>
      {/* Fund identity */}
      <View style={styles.identityRow}>
        <View style={styles.identity}>
          <AppText
            variant="title"
            style={styles.fundName}
          >
            {fund.name}
          </AppText>

          <View style={styles.metaRow}>
            <AppText
              variant="caption"
              color={colors.subtitle}
            >
              {fund.isin}
            </AppText>

            <View style={styles.dot} />

            <AppText
              variant="caption"
              color={colors.subtitle}
            >
              {currency}
            </AppText>
          </View>
        </View>

        <View style={styles.currencyChip}>
          <AppText style={styles.currencyText}>
            {currency}
          </AppText>
        </View>
      </View>

      {/* Current NAV hero */}
      <View style={styles.navSection}>
        <View style={styles.navLabelRow}>
          <AppText
            variant="caption"
            color={colors.subtitle}
          >
            Current NAV
          </AppText>

          {performance.nav_date && (
            <AppText
              variant="caption"
              color={colors.subtitle}
            >
              {formatDate(performance.nav_date)}
            </AppText>
          )}
        </View>

        <AppText
          variant="title"
          style={styles.nav}
        >
          {formatCurrency(
            latestNav,
            currency,
          )}
        </AppText>

        <AppText
          variant="caption"
          color={colors.subtitle}
        >
          Latest reported net asset value
        </AppText>
      </View>

      {/* Executive metrics */}
      <View style={styles.divider} />

      <View style={styles.metricsGrid}>
        <Metric
          label="Daily"
          value={formatPercentage(
            performance.daily_return,
          )}
        />

        <Metric
          label="Monthly"
          value={formatPercentage(
            performance.monthly_return,
          )}
        />

        <Metric
          label="YTD"
          value={formatPercentage(
            performance.ytd_return,
          )}
        />

        <Metric
          label="7D Average"
          value={formatCurrency(
            performance.moving_average_7,
            currency,
          )}
        />

        <Metric
          label="30D Average"
          value={formatCurrency(
            performance.moving_average_30,
            currency,
          )}
        />
      </View>
    </AppCard>
  );
}

function Metric({
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
        variant="body"
        style={styles.metricValue}
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

  identityRow: {
    flexDirection: "row",
    alignItems: "flex-start",
    justifyContent: "space-between",
  },

  identity: {
    flex: 1,
    minWidth: 0,
    marginRight: spacing.md,
  },

  fundName: {
    marginBottom: spacing.xs,
  },

  metaRow: {
    flexDirection: "row",
    alignItems: "center",
  },

  dot: {
    width: 4,
    height: 4,
    borderRadius: 2,
    backgroundColor: colors.subtitle,
    marginHorizontal: spacing.sm,
  },

  currencyChip: {
    backgroundColor: colors.primary,
    borderRadius: 999,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
  },

  currencyText: {
    color: "#FFFFFF",
    fontWeight: "700",
  },

  navSection: {
    marginTop: spacing.xl,
  },

  navLabelRow: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },

  nav: {
    marginTop: spacing.xs,
    marginBottom: spacing.xs,
    fontSize: 38,
    fontWeight: "800",
  },

  divider: {
    height: StyleSheet.hairlineWidth,
    backgroundColor: colors.border,
    marginVertical: spacing.lg,
  },

  metricsGrid: {
    flexDirection: "row",
    flexWrap: "wrap",
    marginHorizontal: -spacing.xs,
  },

  metric: {
    width: "20%",
    minWidth: 80,
    paddingHorizontal: spacing.xs,
    marginBottom: spacing.sm,
  },

  metricLabel: {
    marginBottom: 3,
  },

  metricValue: {
    fontWeight: "700",
  },
});