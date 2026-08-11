import React, { useMemo, useState } from 'react';
import {
  ScrollView,
  StyleSheet,
  Pressable,
  View,
} from 'react-native';

import { useRouter } from 'expo-router';

import AppCard from '@/components/common/AppCard';
import AppText from '@/components/common/AppText';

import colors from '@/constants/colors';
import spacing from '@/constants/spacing';

import type { FundRanking } from '@/models/FundRanking';

interface RankingData {
  top_ytd: FundRanking[];
  top_monthly: FundRanking[];
  top_weekly: FundRanking[];
  top_daily: FundRanking[];
  lowest_risk: FundRanking[];
  highest_risk: FundRanking[];
  worst_drawdown: FundRanking[];
}

interface Props {
  rankings: RankingData;
}

type RankingKey = keyof RankingData;

interface RankingTab {
  key: RankingKey;
  label: string;
  shortLabel: string;
}

const TABS: RankingTab[] = [
  {
    key: 'top_ytd',
    label: 'YTD Return',
    shortLabel: 'YTD',
  },
  {
    key: 'top_monthly',
    label: 'Monthly Return',
    shortLabel: 'Monthly',
  },
  {
    key: 'top_weekly',
    label: 'Weekly Return',
    shortLabel: 'Weekly',
  },
  {
    key: 'top_daily',
    label: 'Daily Return',
    shortLabel: 'Daily',
  },
  {
    key: 'lowest_risk',
    label: 'Lowest Risk',
    shortLabel: 'Low Risk',
  },
  {
    key: 'highest_risk',
    label: 'Highest Risk',
    shortLabel: 'High Risk',
  },
  {
    key: 'worst_drawdown',
    label: 'Worst Drawdown',
    shortLabel: 'Drawdown',
  },
];

function formatPercentage(value: unknown): string {
  const numericValue = Number(value);

  if (!Number.isFinite(numericValue)) {
    return '—';
  }

  return `${(numericValue * 100).toFixed(2)}%`;
}

function getMetricValue(
  fund: FundRanking,
  rankingKey: RankingKey,
): string {
  switch (rankingKey) {
    case 'top_ytd':
      return formatPercentage(fund.ytd_return);

    case 'top_monthly':
      return formatPercentage(fund.monthly_return);

    case 'top_weekly':
      return formatPercentage(fund.weekly_return);

    case 'top_daily':
      return formatPercentage(fund.daily_return);

    case 'lowest_risk':
    case 'highest_risk':
      return `${(Number(fund.volatility) * 100).toFixed(2)}%`;

    case 'worst_drawdown':
      return formatPercentage(fund.drawdown);

    default:
      return '—';
  }
}

function getMetricLabel(
  rankingKey: RankingKey,
): string {
  switch (rankingKey) {
    case 'top_ytd':
      return 'YTD';

    case 'top_monthly':
      return 'Monthly';

    case 'top_weekly':
      return 'Weekly';

    case 'top_daily':
      return 'Daily';

    case 'lowest_risk':
    case 'highest_risk':
      return 'Volatility';

    case 'worst_drawdown':
      return 'Drawdown';

    default:
      return '';
  }
}

function getValueColor(
  fund: FundRanking,
  rankingKey: RankingKey,
): string {
  switch (rankingKey) {
    case 'top_ytd':
      return Number(fund.ytd_return) >= 0
        ? colors.success
        : colors.danger;

    case 'top_monthly':
      return Number(fund.monthly_return) >= 0
        ? colors.success
        : colors.danger;

    case 'top_weekly':
      return Number(fund.weekly_return) >= 0
        ? colors.success
        : colors.danger;

    case 'top_daily':
      return Number(fund.daily_return) >= 0
        ? colors.success
        : colors.danger;

    case 'lowest_risk':
      return colors.success;

    case 'highest_risk':
      return colors.danger;

    case 'worst_drawdown':
      return colors.danger;

    default:
      return colors.primary;
  }
}

function getRankingDescription(
  rankingKey: RankingKey,
): string {
  switch (rankingKey) {
    case 'top_ytd':
      return 'Funds ranked by year-to-date performance.';

    case 'top_monthly':
      return 'Funds ranked by monthly performance.';

    case 'top_weekly':
      return 'Funds ranked by weekly performance.';

    case 'top_daily':
      return 'Funds ranked by daily performance.';

    case 'lowest_risk':
      return 'Funds ranked from lowest to highest volatility.';

    case 'highest_risk':
      return 'Funds ranked from highest to lowest volatility.';

    case 'worst_drawdown':
      return 'Funds ranked by largest portfolio drawdown.';

    default:
      return '';
  }
}

export default function RankingTabs({
  rankings,
}: Props) {
  const router = useRouter();

  const [activeTab, setActiveTab] =
    useState<RankingKey>('top_ytd');

  const activeRanking = useMemo(
    () => rankings?.[activeTab] ?? [],
    [rankings, activeTab],
  );

  const activeTabData = TABS.find(
    (tab) => tab.key === activeTab,
  );

  const handleFundPress = (fund: FundRanking) => {
    router.push(`/fund/${fund.id}`);
  };

  return (
    <AppCard style={styles.card}>
      <View style={styles.header}>
        <View style={styles.headerText}>
          <AppText
            variant="body"
            style={styles.title}
          >
            Fund Rankings
          </AppText>

          <AppText
            variant="caption"
            color={colors.subtitle}
          >
            {activeTabData?.label}
          </AppText>
        </View>
      </View>

      {/* Ranking tabs */}
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.tabsContent}
        style={styles.tabs}
      >
        {TABS.map((tab) => {
          const isActive =
            tab.key === activeTab;

          return (
            <Pressable
              key={tab.key}
              onPress={() =>
                setActiveTab(tab.key)
              }
              style={[
                styles.tab,
                isActive && styles.activeTab,
              ]}
            >
              <AppText
                variant="caption"
                color={
                  isActive
                    ? '#FFFFFF'
                    : colors.text
                }
                style={[
                  styles.tabText,
                  isActive &&
                    styles.activeTabText,
                ]}
              >
                {tab.shortLabel}
              </AppText>
            </Pressable>
          );
        })}
      </ScrollView>

      <AppText
        variant="caption"
        color={colors.subtitle}
        style={styles.description}
      >
        {getRankingDescription(activeTab)}
      </AppText>

      {/* Ranking list */}
      <View style={styles.list}>
        {activeRanking.map((fund, index) => {
          const value = getMetricValue(
            fund,
            activeTab,
          );

          const valueColor = getValueColor(
            fund,
            activeTab,
          );

          return (
            <Pressable
              key={`${activeTab}-${fund.isin}`}
              onPress={() =>
                handleFundPress(fund)
              }
              style={({ pressed }) => [
                styles.row,
                pressed && styles.rowPressed,
              ]}
              accessibilityRole="button"
              accessibilityLabel={`Open ${fund.name}`}
            >
              {/* Rank */}
              <View style={styles.rankCircle}>
                <AppText
                  variant="caption"
                  color="#FFFFFF"
                  style={styles.rankText}
                >
                  {fund.rank ?? index + 1}
                </AppText>
              </View>

              {/* Fund information */}
              <View style={styles.fundInfo}>
                <AppText
                  variant="caption"
                  style={styles.fundName}
                  numberOfLines={1}
                >
                  {fund.name}
                </AppText>

                <AppText
                  variant="caption"
                  color={colors.subtitle}
                  style={styles.isin}
                >
                  {fund.isin}
                </AppText>

                <AppText
                  variant="caption"
                  color={colors.subtitle}
                  style={styles.nav}
                >
                  NAV {fund.currency}{' '}
                  {Number(fund.nav).toFixed(2)}
                </AppText>
              </View>

              {/* Ranking metric */}
              <View style={styles.metric}>
                <AppText
                  variant="caption"
                  color={colors.subtitle}
                  style={styles.metricLabel}
                >
                  {getMetricLabel(activeTab)}
                </AppText>

                <AppText
                  variant="body"
                  color={valueColor}
                  style={styles.metricValue}
                >
                  {value}
                </AppText>
              </View>
            </Pressable>
          );
        })}
      </View>

      {!activeRanking.length && (
        <View style={styles.emptyState}>
          <AppText
            variant="caption"
            color={colors.subtitle}
          >
            No ranking data available.
          </AppText>
        </View>
      )}
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginTop: spacing.md,
    marginHorizontal: spacing.md,
    padding: spacing.md,
  },

  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },

  headerText: {
    flex: 1,
  },

  title: {
    fontWeight: '700',
  },

  tabs: {
    marginTop: spacing.md,
    marginHorizontal: -spacing.md,
  },

  tabsContent: {
    paddingHorizontal: spacing.md,
    gap: spacing.xs,
  },

  tab: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderRadius: 20,
    backgroundColor: colors.background,
    borderWidth: 1,
    borderColor: colors.border,
  },

  activeTab: {
    backgroundColor: colors.primary,
    borderColor: colors.primary,
  },

  tabText: {
    fontWeight: '600',
  },

  activeTabText: {
    fontWeight: '700',
  },

  description: {
    marginTop: spacing.sm,
  },

  list: {
    marginTop: spacing.md,
  },

  row: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: spacing.sm,
    borderBottomWidth:
      StyleSheet.hairlineWidth,
    borderBottomColor: colors.border,
  },

  rowPressed: {
    opacity: 0.65,
    backgroundColor: colors.background,
  },

  rankCircle: {
    width: 28,
    height: 28,
    borderRadius: 14,
    backgroundColor: colors.primary,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: spacing.sm,
  },

  rankText: {
    fontWeight: '700',
  },

  fundInfo: {
    flex: 1,
    minWidth: 0,
  },

  fundName: {
    fontWeight: '600',
  },

  isin: {
    marginTop: 2,
    fontSize: 10,
  },

  nav: {
    marginTop: 2,
    fontSize: 10,
  },

  metric: {
    alignItems: 'flex-end',
    marginLeft: spacing.sm,
    minWidth: 70,
  },

  metricLabel: {
    fontSize: 10,
  },

  metricValue: {
    marginTop: 2,
    fontWeight: '700',
  },

  emptyState: {
    paddingVertical: spacing.lg,
    alignItems: 'center',
  },
});