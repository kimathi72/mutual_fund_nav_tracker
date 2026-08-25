// components/dashboard/TopMoversSection.tsx

import React from 'react';
import {
  Pressable,
  StyleSheet,
  View,
} from 'react-native';

import { useRouter } from 'expo-router';

import type { RankingReport } from '@/models/RankingReport';
import type { FundRanking } from '@/models/FundRanking';

import AppCard from '@/components/common/AppCard';
import AppText from '@/components/common/AppText';
import SectionHeader from '@/components/common/SectionHeader';

import formatPercentage from '@/utils/formatPercentage';

import colors from '@/constants/colors';
import spacing from '@/constants/spacing';

interface Props {
  rankings: RankingReport;
}

export default function TopMoversSection({
  rankings,
}: Props) {
  const router = useRouter();

  const funds = rankings.top_ytd.slice(0, 3);

  if (!funds.length) {
    return null;
  }

  return (
    <View style={styles.container}>
      <SectionHeader
        title="Top Movers"
      />

      {funds.map((fund, index) => (
        <FundRow
          key={`${fund.isin}-${fund.id}`}
          fund={fund}
          rank={index + 1}
          onPress={() =>
            router.push(`/fund/${fund.id}`)
          }
        />
      ))}
    </View>
  );
}

interface RowProps {
  fund: FundRanking;
  rank: number;
  onPress: () => void;
}

function FundRow({
  fund,
  rank,
  onPress,
}: RowProps) {
  const ytdReturn = Number(fund.ytd_return);

  const hasValidReturn =
    Number.isFinite(ytdReturn);

  const returnColor =
    !hasValidReturn || ytdReturn === 0
      ? colors.subtitle
      : ytdReturn > 0
        ? colors.success
        : colors.danger;

  return (
    <Pressable
      onPress={onPress}
      accessibilityRole="button"
      accessibilityLabel={`View ${fund.name}`}
    >
      <AppCard style={styles.card}>
        <View style={styles.row}>
          <View style={styles.left}>
            <View style={styles.rank}>
              <AppText
                variant="body"
                color="#FFFFFF"
                style={styles.rankText}
              >
                {rank}
              </AppText>
            </View>

            <View style={styles.info}>
              <AppText variant="body">
                {fund.name}
              </AppText>

              <AppText
                variant="caption"
                color={colors.subtitle}
              >
                {fund.isin}
              </AppText>

              <AppText
                variant="caption"
                color={colors.subtitle}
                style={styles.nav}
              >
                NAV {String(fund.nav)}
              </AppText>
            </View>
          </View>

          <View style={styles.right}>
            <AppText
              variant="body"
              style={[
                styles.return,
                {
                  color: returnColor,
                },
              ]}
            >
              {hasValidReturn
                ? formatPercentage(ytdReturn)
                : 'N/A'}
            </AppText>

            <AppText
              variant="caption"
              color={colors.subtitle}
            >
              YTD
            </AppText>
          </View>
        </View>
      </AppCard>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  container: {
    marginHorizontal: spacing.md,
    marginBottom: spacing.lg,
  },

  card: {
    marginTop: spacing.sm,
  },

  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },

  left: {
    flexDirection: 'row',
    flex: 1,
    alignItems: 'center',
    paddingRight: spacing.md,
  },

  rank: {
    width: 38,
    height: 38,
    borderRadius: 19,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: colors.primary,
    marginRight: spacing.md,
  },

  rankText: {
    fontWeight: '700',
  },

  info: {
    flex: 1,
  },

  nav: {
    marginTop: spacing.xs,
  },

  right: {
    alignItems: 'flex-end',
  },

  return: {
    fontWeight: '700',
  },
});