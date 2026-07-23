import React from "react";
import {
  ScrollView,
  StyleSheet,
  Pressable,
  View,
} from "react-native";

import { useRouter } from "expo-router";

import AppScreen from "@/components/common/AppScreen";
import LoadingView from "@/components/common/LoadingView";
import { ErrorView } from "@/components/common/ErrorView";
import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";
import SectionHeader from "@/components/common/SectionHeader";

import { useRankings } from "@/hooks/useRankings";

import { FundRanking } from "@/models/FundRanking";

import formatPercentage from "@/utils/formatPercentage";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

interface SectionConfig {
  title: string;
  metric: string;
  data: FundRanking[];
}

export default function RankingScreen() {
  const router = useRouter();

  const {
    data,
    isLoading,
    isError,
    refetch,
  } = useRankings();

  if (isLoading) {
    return <LoadingView />;
  }

  if (isError) {
    return (
      <ErrorView
        message="Unable to load rankings."
        onRetry={() => refetch()}
      />
    );
  }

  if (!data) {
    return (
      <AppScreen>
        <AppText>No rankings available.</AppText>
      </AppScreen>
    );
  }

  const sections: SectionConfig[] = [
    {
      title: "Top YTD",
      metric: "ytd_return",
      data: data.top_ytd,
    },
    {
      title: "Top Monthly",
      metric: "monthly_return",
      data: data.top_monthly,
    },
    {
      title: "Top Weekly",
      metric: "weekly_return",
      data: data.top_weekly,
    },
    {
      title: "Top Daily",
      metric: "daily_return",
      data: data.top_daily,
    },
    {
      title: "Lowest Risk",
      metric: "volatility_30",
      data: data.lowest_risk,
    },
    {
      title: "Highest Risk",
      metric: "volatility_30",
      data: data.highest_risk,
    },
    {
      title: "Largest Drawdown",
      metric: "drawdown",
      data: data.largest_drawdown,
    },
  ];

  return (
    <AppScreen>
      <ScrollView
        showsVerticalScrollIndicator={false}
      >
        {sections.map(section => (
          <RankingSection
            key={section.title}
            title={section.title}
            metric={section.metric}
            data={section.data}
            onPress={(id) =>
              router.push(`/fund/${id}`)
            }
          />
        ))}
      </ScrollView>
    </AppScreen>
  );
}

interface SectionProps {
  title: string;
  metric: string;
  data: FundRanking[];
  onPress: (id: number) => void;
}

function RankingSection({
  title,
  metric,
  data,
  onPress,
}: SectionProps) {
  if (!data.length) return null;

  return (
    <View style={styles.section}>
      <SectionHeader title={title} />

      {data.map((fund, index) => (
        <RankingRow
          key={fund.fund_id}
          rank={index + 1}
          fund={fund}
          metric={metric}
          onPress={() =>
            onPress(fund.fund_id)
          }
        />
      ))}
    </View>
  );
}

interface RowProps {
  rank: number;
  metric: string;
  fund: FundRanking;
  onPress: () => void;
}

function RankingRow({
  rank,
  metric,
  fund,
  onPress,
}: RowProps) {
  return (
    <Pressable onPress={onPress}>
      <AppCard style={styles.card}>
        <View style={styles.row}>
          <View style={styles.left}>
            <View style={styles.rankCircle}>
              <AppText style={styles.rankText}>
                {rank}
              </AppText>
            </View>

            <View style={styles.info}>
              <AppText variant="heading">
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
            <AppText style={styles.metricValue}>
              {formatMetric(fund, metric)}
            </AppText>

            <AppText
              variant="caption"
              color={colors.subtitle}
            >
              {metricLabel(metric)}
            </AppText>
          </View>
        </View>
      </AppCard>
    </Pressable>
  );
}

function formatMetric(
  fund: FundRanking,
  metric: string
): string {
  switch (metric) {
    case "daily_return":
      return formatPercentage(
        Number(fund.daily_return)
      );

    case "weekly_return":
      return formatPercentage(
        Number(fund.weekly_return)
      );

    case "monthly_return":
      return formatPercentage(
        Number(fund.monthly_return)
      );

    case "ytd_return":
      return formatPercentage(
        Number(fund.ytd_return)
      );

    case "volatility_30":
      return formatPercentage(
        Number(fund.volatility_30)
      );

    case "drawdown":
      return formatPercentage(
        Number(fund.drawdown)
      );

    default:
      return "-";
  }
}

function metricLabel(metric: string): string {
  switch (metric) {
    case "daily_return":
      return "Daily";

    case "weekly_return":
      return "Weekly";

    case "monthly_return":
      return "Monthly";

    case "ytd_return":
      return "YTD";

    case "volatility_30":
      return "Risk";

    case "drawdown":
      return "Drawdown";

    default:
      return "";
  }
}

const styles = StyleSheet.create({
  section: {
    marginBottom: spacing.xl,
  },

  card: {
    marginBottom: spacing.sm,
  },

  row: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },

  left: {
    flexDirection: "row",
    alignItems: "center",
    flex: 1,
  },

  info: {
    flex: 1,
  },

  rankCircle: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: colors.primary,
    justifyContent: "center",
    alignItems: "center",
    marginRight: spacing.md,
  },

  rankText: {
    color: "#FFF",
    fontWeight: "700",
  },

  right: {
    alignItems: "flex-end",
    minWidth: 90,
  },

  metricValue: {
    fontWeight: "700",
    fontSize: 16,
    color: colors.success,
  },
});