import React from "react";
import { StyleSheet, View } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import { SparkLine } from "@/components/charts";

import colors from "@/constants/colors";
import Spacing from "@/constants/spacing";
import FundCard from "./FundCard";

type Props = {
  title: string;
  value: string;
  trend: number[];
};

export default function KPITrendCard({
  title,
  value,
  trend,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <AppText variant="caption">
        {title}
      </AppText>

      <AppText variant="heading">
        {value}
      </AppText>

      <View style={styles.chart}>
        <SparkLine
          data={trend.map((value, index) => ({
            date: String(index),
            value,
          }))}
        />
      </View>
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: Spacing.md,
  },

  chart: {
    marginTop: Spacing.md,
    alignItems: "center",
  },
});