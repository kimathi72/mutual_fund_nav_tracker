// components/dashboard/RiskAnalysisSection.tsx

import React from 'react';
import {
  StyleSheet,
  View,
} from 'react-native';

import AppCard from '../common/AppCard';
import AppText from '../common/AppText';

import RiskHeatMap from '../charts/RiskHeatMap';

import type { PortfolioSummary } from '../../models/PortfolioSummary';
import type { FundSummary } from '../../models/FundSummary';

import colors from '../../constants/colors';
import spacing from '../../constants/spacing';

interface Props {
  summary: PortfolioSummary;
  funds: FundSummary[];
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

export default function RiskAnalysisSection({
  summary,
  funds,
}: Props) {
  const highestRisk = summary.highest_risk;
  const lowestRisk = summary.lowest_risk;

  return (
    <AppCard style={styles.card}>
      <AppText
        variant="body"
        style={styles.title}
      >
        Risk Analysis
      </AppText>

      <View style={styles.riskSummaryRow}>
        {/* Highest Risk */}
        <View
          style={[
            styles.riskCard,
            styles.highRiskCard,
          ]}
        >
          <View style={styles.cardHeader}>
            <View
              style={[
                styles.statusDot,
                {
                  backgroundColor:
                    colors.danger,
                },
              ]}
            />

            <AppText
              variant="caption"
              color={colors.subtitle}
            >
              Highest Risk
            </AppText>
          </View>

          <AppText
            variant="caption"
            style={styles.fundName}
            numberOfLines={2}
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
                style={styles.metricValue}
              >
                {formatPercentage(
                  highestRisk?.volatility,
                )}
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
                style={styles.metricValue}
              >
                {formatPercentage(
                  highestRisk?.drawdown,
                )}
              </AppText>
            </View>
          </View>
        </View>

        {/* Lowest Risk */}
        <View
          style={[
            styles.riskCard,
            styles.lowRiskCard,
          ]}
        >
          <View style={styles.cardHeader}>
            <View
              style={[
                styles.statusDot,
                {
                  backgroundColor:
                    colors.success,
                },
              ]}
            />

            <AppText
              variant="caption"
              color={colors.subtitle}
            >
              Lowest Risk
            </AppText>
          </View>

          <AppText
            variant="caption"
            style={styles.fundName}
            numberOfLines={2}
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
                style={styles.metricValue}
              >
                {formatPercentage(
                  lowestRisk?.volatility,
                )}
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
                style={styles.metricValue}
              >
                {formatPercentage(
                  lowestRisk?.drawdown,
                )}
              </AppText>
            </View>
          </View>
        </View>
      </View>

      <View style={styles.divider} />

      <RiskHeatMap
        funds={funds}
      />
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginTop: spacing.md,
    marginHorizontal: spacing.md,
    padding: spacing.md,
  },

  title: {
    fontWeight: '700',
    marginBottom: spacing.md,
  },

  riskSummaryRow: {
    flexDirection: 'row',
    gap: spacing.sm,
  },

  riskCard: {
    flex: 1,
    minWidth: 0,
    padding: spacing.sm,
    borderRadius: 12,
    backgroundColor: colors.background,
    borderWidth: 1,
    borderColor: colors.border,
  },

  highRiskCard: {
    borderTopWidth: 3,
    borderTopColor: colors.danger,
  },

  lowRiskCard: {
    borderTopWidth: 3,
    borderTopColor: colors.success,
  },

  cardHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xs,
    marginBottom: spacing.sm,
  },

  statusDot: {
    width: 7,
    height: 7,
    borderRadius: 4,
  },

  fundName: {
    fontWeight: '600',
    lineHeight: 15,
    minHeight: 30,
    marginBottom: spacing.sm,
  },

  metricsRow: {
    flexDirection: 'row',
    gap: spacing.lg,
  },

  metric: {
    flex: 1,
    minWidth: 0,
  },

  metricValue: {
    marginTop: 2,
    fontWeight: '700',
  },

  divider: {
    height: StyleSheet.hairlineWidth,
    backgroundColor: colors.border,
    marginVertical: spacing.md,
  },
});