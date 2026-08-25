
import React from 'react';
import { StyleSheet, View } from 'react-native';

import AppText from '../common/AppText';

import type { PortfolioSummary } from '../../models/PortfolioSummary';

import colors from '../../constants/colors';
import spacing from '../../constants/spacing';

interface Props {
  summary: PortfolioSummary;
  embedded?: boolean;
}

const formatPercentage = (
  value: number | string | undefined,
): string => {
  const numericValue = Number(value);

  if (!Number.isFinite(numericValue)) {
    return 'N/A';
  }

  return `${(numericValue * 100).toFixed(2)}%`;
};

export default function RiskOverviewCard({
  summary,
  embedded = false,
}: Props) {
  const highestRisk = summary.highest_risk;
  const lowestRisk = summary.lowest_risk;

  const content = (
    <>
      <View style={styles.section}>
        <AppText
          variant="caption"
          color={colors.subtitle}
        >
          Highest Risk
        </AppText>

        <AppText
          variant="body"
          style={styles.fundName}
        >
          {highestRisk?.fund_name ?? 'N/A'}
        </AppText>

        <View style={styles.metricsRow}>
          <View style={styles.metric}>
            <AppText
              variant="caption"
              color={colors.subtitle}
            >
              Volatility
            </AppText>

            <AppText
              variant="body"
              color={colors.danger}
            >
              {formatPercentage(highestRisk?.volatility)}
            </AppText>
          </View>

          <View style={styles.metric}>
            <AppText
              variant="caption"
              color={colors.subtitle}
            >
              Drawdown
            </AppText>

            <AppText
              variant="body"
              color={colors.danger}
            >
              {formatPercentage(highestRisk?.drawdown)}
            </AppText>
          </View>
        </View>
      </View>

      <View style={styles.divider} />

      <View style={styles.section}>
        <AppText
          variant="caption"
          color={colors.subtitle}
        >
          Lowest Risk
        </AppText>

        <AppText
          variant="body"
          style={styles.fundName}
        >
          {lowestRisk?.fund_name ?? 'N/A'}
        </AppText>

        <View style={styles.metricsRow}>
          <View style={styles.metric}>
            <AppText
              variant="caption"
              color={colors.subtitle}
            >
              Volatility
            </AppText>

            <AppText
              variant="body"
              color={colors.success}
            >
              {formatPercentage(lowestRisk?.volatility)}
            </AppText>
          </View>

          <View style={styles.metric}>
            <AppText
              variant="caption"
              color={colors.subtitle}
            >
              Drawdown
            </AppText>

            <AppText
              variant="body"
              color={colors.success}
            >
              {formatPercentage(lowestRisk?.drawdown)}
            </AppText>
          </View>
        </View>
      </View>
    </>
  );

  if (embedded) {
    return <View>{content}</View>;
  }

  return (
    <View style={styles.card}>
      <AppText
        variant="body"
        style={styles.title}
      >
        Risk Overview
      </AppText>

      {content}
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    marginHorizontal: spacing.md,
    marginTop: spacing.md,
    padding: spacing.md,
    borderRadius: 16,
    backgroundColor: colors.background,
  },

  title: {
    fontWeight: '700',
    marginBottom: spacing.lg,
  },

  section: {
    gap: spacing.xs,
  },

  fundName: {
    fontWeight: '600',
    marginBottom: spacing.sm,
  },

  metricsRow: {
    flexDirection: 'row',
    gap: spacing.xl,
  },

  metric: {
    flex: 1,
    gap: spacing.xs,
  },

  divider: {
    height: StyleSheet.hairlineWidth,
    backgroundColor: colors.border,
    marginVertical: spacing.lg,
  },
});