import React from "react";
import { StyleSheet } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import spacing from "@/constants/spacing";

type Props = {
  summary: string;
};

export default function FundInsight({
  summary,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <AppText variant="heading">
        Executive Insight
      </AppText>

      <AppText>
        {summary}
      </AppText>
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.xl,
  },
});