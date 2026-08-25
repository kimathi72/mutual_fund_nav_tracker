// components/charts/RiskHeatMap.tsx

import React from 'react';
import {
  ScrollView,
  StyleSheet,
  View,
} from 'react-native';

import AppText from '../common/AppText';

import type { FundSummary } from '../../models/FundSummary';

import colors from '../../constants/colors';
import spacing from '../../constants/spacing';

interface Props {
  funds: FundSummary[];
}

const toNumber = (
  value: number | string | undefined,
): number => {
  const numericValue = Number(value);

  return Number.isFinite(numericValue)
    ? numericValue
    : 0;
};

const getRiskColor = (
  volatility: number,
): string => {
  const percentage = volatility * 100;

  if (percentage >= 35) {
    return colors.danger;
  }

  if (percentage >= 15) {
    return colors.warning;
  }

  return colors.success;
};

export default function RiskHeatMap({
  funds,
}: Props) {
  if (!funds?.length) {
    return null;
  }

  return (
    <View style={styles.container}>
      <AppText
        variant="caption"
        color={colors.subtitle}
        style={styles.subtitle}
      >
        Current Risk Exposure
      </AppText>

      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.list}
      >
        {funds.map((fund) => {
          const volatility = toNumber(
            fund.volatility,
          );

          const riskColor =
            getRiskColor(volatility);

          return (
            <View
              key={fund.id ?? fund.isin}
              style={[
                styles.fundCard,
                {
                  borderTopColor: riskColor,
                },
              ]}
            >
              <View
                style={[
                  styles.indicator,
                  {
                    backgroundColor: riskColor,
                  },
                ]}
              />

              <AppText
                variant="caption"
                style={styles.fundName}
                numberOfLines={2}
              >
                {fund.name}
              </AppText>

              <View style={styles.valueRow}>
                <AppText
                  variant="caption"
                  color={colors.subtitle}
                >
                  Volatility
                </AppText>

                <AppText
                  variant="body"
                  color={riskColor}
                  style={styles.value}
                >
                  {(volatility * 100).toFixed(2)}%
                </AppText>
              </View>
            </View>
          );
        })}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginTop: spacing.sm,
  },

  subtitle: {
    marginBottom: spacing.sm,
  },

  list: {
    gap: spacing.sm,
    paddingRight: spacing.md,
  },

  fundCard: {
    width: 190,
    minHeight: 86,
    padding: spacing.sm,
    borderRadius: 12,
    backgroundColor: colors.background,
    borderWidth: 1,
    borderColor: colors.border,
    borderTopWidth: 3,
  },

  indicator: {
    width: 8,
    height: 8,
    borderRadius: 4,
    marginBottom: spacing.xs,
  },

  fundName: {
    fontWeight: '600',
    lineHeight: 15,
    minHeight: 30,
  },

  valueRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginTop: spacing.sm,
  },

  value: {
    fontWeight: '700',
  },
});