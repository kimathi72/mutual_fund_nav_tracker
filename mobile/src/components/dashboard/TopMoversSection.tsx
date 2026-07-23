import React from "react";
import {
  Pressable,
  StyleSheet,
  View,
} from "react-native";

import { useRouter } from "expo-router";

import type { RankingReport } from "@/models/RankingReport";
import type { FundRanking } from "@/models/FundRanking";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";
import SectionHeader from "@/components/common/SectionHeader";

import formatPercentage from "@/utils/formatPercentage";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

interface Props {
  rankings: RankingReport;
}

export default function TopMoversSection({
  rankings,
}: Props) {
  const router = useRouter();

  const funds =
    rankings.top_ytd.slice(0, 3);

  return (
    <View style={styles.container}>
      <SectionHeader
        title="Top Movers"
        subtitle="Best YTD performers"
      />

      {funds.map((fund, index) => (
        <FundRow
          key={fund.fund_id}
          fund={fund}
          rank={index + 1}
          onPress={() =>
            router.push(`/fund/${fund.fund_id}`)
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
  return (
    <Pressable onPress={onPress}>
      <AppCard style={styles.card}>
        <View style={styles.row}>
          <View style={styles.left}>
            <View style={styles.rank}>
              <AppText
                variant="body"
                color="#FFF"
              >
                {rank}
              </AppText>
            </View>

            <View style={styles.info}>
              <AppText variant="body">
                {fund.fund_name}
              </AppText>

              <AppText
                variant="caption"
                color={colors.subtitle}
              >
                {fund.isin}
              </AppText>
            </View>
          </View>

          <View style={styles.right}>
            <AppText
              variant="body"
              style={[
                styles.return,
                {
                  color:
                    fund.ytd_return >= 0
                      ? colors.success
                      : colors.danger,
                },
              ]}
            >
              {formatPercentage(
                fund.ytd_return
              )}
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
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },

  left: {
    flexDirection: "row",
    flex: 1,
    alignItems: "center",
  },

  rank: {
    width: 38,
    height: 38,
    borderRadius: 19,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: colors.primary,
    marginRight: spacing.md,
  },

  info: {
    flex: 1,
  },

  right: {
    alignItems: "flex-end",
  },

  return: {
    fontWeight: "700",
  },
});