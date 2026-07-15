import { Pressable, StyleSheet, View } from "react-native";
import { useRouter } from "expo-router";

import { RankingReport } from "@/models/RankingReport";
import { FundRanking } from "@/models/FundRanking";

import  AppCard  from "@/components/common/AppCard";
import  AppText  from "@/components/common/AppText";
import SectionHeader from "@/components/common/SectionHeader";

import  formatPercentage  from "@/utils/formatPercentage";

import  colors  from "@/constants/colors";
import  spacing  from "@/constants/spacing";

type Props = {
  rankings: RankingReport;
};

export default function TopMoversSection({
  rankings,
}: Props) {
  const router = useRouter();

  const funds =
    rankings.top_ytd.slice(0, 3);

  return (
    <View>

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

type RowProps = {
  fund: FundRanking;
  rank: number;
  onPress: () => void;
};

function FundRow({
  fund,
  rank,
  onPress,
}: RowProps) {
  return (
    <Pressable onPress={onPress}>
      <AppCard>

        <View style={styles.row}>

          <View style={styles.left}>

            <View style={styles.rank}>
              <AppText
                weight="bold"
                style={styles.rankText}
              >
                {rank}
              </AppText>
            </View>

            <View style={styles.info}>

              <AppText weight="bold">
                {fund.fund_name}
              </AppText>

              <AppText
                variant="caption"
                style={styles.isin}
              >
                {fund.isin}
              </AppText>

            </View>

          </View>

          <View>

            <AppText
              weight="bold"
              style={styles.return}
            >
              {formatPercentage(
                fund.ytd_return
              )}
            </AppText>

            <AppText
              variant="caption"
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

  row: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },

  left: {
    flexDirection: "row",
    flex: 1,
  },

  rank: {
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: colors.primary,
    justifyContent: "center",
    alignItems: "center",
    marginRight: spacing.md,
  },

  rankText: {
    color: "#FFF",
  },

  info: {
    flex: 1,
  },

  isin: {
    color: colors.secondaryText,
    marginTop: 2,
  },

  return: {
    color: colors.success,
    fontSize: 18,
  },

});