
import React from 'react';
import {
  StyleSheet,
  View,
} from 'react-native';

import KPICard from './KPICard';

import type { PortfolioSummary } from '@/models/PortfolioSummary';

import formatPercentage from '@/utils/formatPercentage';

import spacing from '@/constants/spacing';

interface Props {
  summary: PortfolioSummary;
}

export default function KPIGrid({
  summary,
}: Props) {
  return (
    <View style={styles.container}>
      {/* Portfolio size */}
      <View style={styles.row}>
        <KPICard
          title="Funds"
          value={summary.total_funds}
          subtitle="Portfolio size"
        />

        <KPICard
          title="Opportunity"
          value={Number(
            summary.average_opportunity_score,
          ).toFixed(2) + "%"}
          subtitle="Average score"
        />
      </View>

      {/* Performance */}
      <View style={styles.row}>
        <KPICard
          title="Daily"
          value={formatPercentage(
            summary.average_daily_return,
          )}
        />

        <KPICard
          title="Weekly"
          value={formatPercentage(
            summary.average_weekly_return,
          )}
        />
      </View>

      <View style={styles.row}>
        <KPICard
          title="Monthly"
          value={formatPercentage(
            summary.average_monthly_return,
          )}
        />

        <KPICard
          title="YTD"
          value={formatPercentage(
            summary.average_ytd_return,
          )}
        />
      </View>

      {/* Risk */}
      <View style={styles.row}>
        <KPICard
          title="Volatility"
          value={formatPercentage(
            summary.average_volatility,
          )}
          subtitle="Average portfolio volatility"
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    gap: spacing.md,
    marginHorizontal: spacing.md,
    marginBottom: spacing.md,
  },

  row: {
    flexDirection: 'row',
    gap: spacing.md,
  },
});
