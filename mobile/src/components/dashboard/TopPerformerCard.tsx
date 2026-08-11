// components/dashboard/TopPerformerCard.tsx

import React from 'react';
import { StyleSheet, View } from 'react-native';

import AppCard from '../common/AppCard';
import AppText from '../common/AppText';

import type { PortfolioFundHighlight } from '../../models/PortfolioFundHighlight';

import colors from '../../constants/colors';
import spacing from '../../constants/spacing';

import formatCurrency from '../../utils/formatCurrency';
import formatPercentage from '../../utils/formatPercentage';

interface Props {
  fund: PortfolioFundHighlight;
}

export default function TopPerformerCard({
  fund,
}: Props) {
  const ytdReturn = Number(fund.ytd_return);
  const volatility = Number(fund.volatility);
  const drawdown = Number(fund.drawdown);
  const nav = Number(fund.nav);

  return (
    <AppCard>
      <AppText
        variant="heading"
        style={styles.title}
      >
        Top Performer
      </AppText>

      <AppText
        variant="title"
        style={styles.fundName}
      >
        {fund.fund_name}
      </AppText>

      <AppText
        variant="caption"
        color={colors.subtitle}
      >
        {fund.isin}
      </AppText>

      <View style={styles.metrics}>
        <Metric
          label="NAV"
          value={
            Number.isFinite(nav)
              ? formatCurrency(nav)
              : 'N/A'
          }
        />

        <Metric
          label="YTD"
          value={
            Number.isFinite(ytdReturn)
              ? formatPercentage(ytdReturn)
              : 'N/A'
          }
        />
      </View>

      <View style={styles.metrics}>
        <Metric
          label="Volatility"
          value={
            Number.isFinite(volatility)
              ? formatPercentage(volatility)
              : 'N/A'
          }
        />

        <Metric
          label="Drawdown"
          value={
            Number.isFinite(drawdown)
              ? formatPercentage(drawdown)
              : 'N/A'
          }
        />
      </View>
    </AppCard>
  );
}

interface MetricProps {
  label: string;
  value: string;
}

function Metric({
  label,
  value,
}: MetricProps) {
  return (
    <View style={styles.metric}>
      <AppText
        variant="caption"
        color={colors.subtitle}
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
  title: {
    marginBottom: spacing.lg,
  },

  fundName: {
    marginBottom: spacing.xs,
    fontWeight: '700',
  },

  metrics: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: spacing.lg,
  },

  metric: {
    flex: 1,
  },

  metricValue: {
    marginTop: spacing.xs,
    fontWeight: '600',
  },
});