// components/dashboard/RiskAnalysisSection.tsx

import React from 'react';

import {
  Pressable,
  StyleSheet,
  View,
} from 'react-native';

import AppCard from '../common/AppCard';
import AppText from '../common/AppText';

import RiskHeatMap from '../charts/RiskHeatMap';

import type {
  PortfolioSummary,
} from '../../models/PortfolioSummary';

import type {
  FundSummary,
} from '../../models/FundSummary';

import colors from '../../constants/colors';
import spacing from '../../constants/spacing';

interface Props {
  summary: PortfolioSummary;
  funds: FundSummary[];

  /**
   * Optional navigation/action for the highest-risk fund.
   */
  onHighestRiskPress?: () => void;

  /**
   * Optional navigation/action for the lowest-risk fund.
   */
  onLowestRiskPress?: () => void;
}

const formatPercentage = (
  value: number | string | undefined,
): string => {
  const numericValue = Number(value);

  if (!Number.isFinite(numericValue)) {
    return 'N/A';
  }

  return `${(
    numericValue * 100
  ).toFixed(2)}%`;
};

interface RiskCardProps {
  label: string;
  fundName: string;
  volatility: number | string | undefined;
  drawdown: number | string | undefined;
  color: string;
  onPress?: () => void;
}

function RiskSummaryCard({
  label,
  fundName,
  volatility,
  drawdown,
  color,
  onPress,
}: RiskCardProps) {
  const content = (
    <View
      style={[
        styles.riskCard,
        {
          borderTopColor: color,
        },
      ]}
    >
      <View style={styles.cardHeader}>
        <View
          style={[
            styles.statusDot,
            {
              backgroundColor: color,
            },
          ]}
        />

        <AppText
          variant="caption"
          color={colors.subtitle}
          numberOfLines={1}
        >
          {label}
        </AppText>
      </View>

      <AppText
        variant="caption"
        style={styles.fundName}
        numberOfLines={2}
      >
        {fundName}
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
            color={color}
            style={styles.metricValue}
          >
            {formatPercentage(
              volatility,
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
            color={color}
            style={styles.metricValue}
          >
            {formatPercentage(
              drawdown,
            )}
          </AppText>
        </View>
      </View>
    </View>
  );

  if (!onPress) {
    return content;
  }

  return (
    <Pressable
      onPress={onPress}
      accessibilityRole="button"
      accessibilityLabel={`${label}: ${fundName}`}
      style={({ pressed }) => [
        styles.pressable,
        pressed && styles.pressed,
      ]}
    >
      {content}
    </Pressable>
  );
}

export default function RiskAnalysisSection({
  summary,
  funds,
  onHighestRiskPress,
  onLowestRiskPress,
}: Props) {
  const highestRisk =
    summary.highest_risk;

  const lowestRisk =
    summary.lowest_risk;

  return (
    <AppCard style={styles.card}>
      {/* Section title */}

      <AppText
        variant="body"
        style={styles.title}
      >
        Risk Analysis
      </AppText>

      {/* Risk summary cards */}

      <View
        style={styles.riskSummaryRow}
      >
        <RiskSummaryCard
          label="Highest Risk"
          fundName={
            highestRisk?.fund_name ??
            'N/A'
          }
          volatility={
            highestRisk?.volatility
          }
          drawdown={
            highestRisk?.drawdown
          }
          color={colors.danger}
          onPress={
            onHighestRiskPress
          }
        />

        <RiskSummaryCard
          label="Lowest Risk"
          fundName={
            lowestRisk?.fund_name ??
            'N/A'
          }
          volatility={
            lowestRisk?.volatility
          }
          drawdown={
            lowestRisk?.drawdown
          }
          color={colors.success}
          onPress={
            onLowestRiskPress
          }
        />
      </View>

      {/* Divider */}

      <View
        style={styles.divider}
      />

      {/* Risk heat map */}

      <RiskHeatMap
        funds={funds}
      />
    </AppCard>
  );
}

const styles =
  StyleSheet.create({
    card: {
      marginTop: spacing.md,
      marginHorizontal: spacing.md,
      padding: spacing.md,
    },

    title: {
      fontWeight: '700',
      marginBottom: spacing.sm,
    },

    riskSummaryRow: {
      flexDirection: 'row',
      gap: spacing.sm,
    },

    pressable: {
      flex: 1,
      minWidth: 0,
    },

    pressed: {
      opacity: 0.82,
    },

    riskCard: {
      flex: 1,
      minWidth: 0,

      paddingHorizontal:
        spacing.sm,

      paddingVertical:
        spacing.sm,

      borderRadius: 12,

      backgroundColor:
        colors.background,

      borderWidth: 1,

      borderColor:
        colors.border,

      borderTopWidth: 3,
    },

    cardHeader: {
      flexDirection: 'row',

      alignItems: 'center',

      gap: spacing.xs,

      marginBottom:
        spacing.xs,
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

      marginBottom:
        spacing.sm,
    },

    metricsRow: {
      flexDirection: 'row',

      gap: spacing.md,
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
      height:
        StyleSheet.hairlineWidth,

      backgroundColor:
        colors.border,

      marginVertical:
        spacing.md,
    },
  });