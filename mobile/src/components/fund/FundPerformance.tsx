import React from "react";
import { StyleSheet } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import spacing from "@/constants/spacing";

import formatPercentage from "@/utils/formatPercentage";

type Props = {
  daily: number;
  weekly: number;
  monthly: number;
  ytd: number;
};

export default function FundPerformance({
  daily,
  weekly,
  monthly,
  ytd,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <AppText variant="heading">
        Performance
      </AppText>

      <AppText>
        Daily: {formatPercentage(daily)}
      </AppText>

      <AppText>
        Weekly: {formatPercentage(weekly)}
      </AppText>

      <AppText>
        Monthly: {formatPercentage(monthly)}
      </AppText>

      <AppText>
        YTD: {formatPercentage(ytd)}
      </AppText>
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.lg,
  },
});