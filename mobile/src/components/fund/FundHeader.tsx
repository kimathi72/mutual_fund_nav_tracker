import React from "react";
import { StyleSheet } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import spacing from "@/constants/spacing";

import formatCurrency from "@/utils/formatCurrency";

type Props = {
  name: string;
  isin: string;
  nav: number;
  currency: string;
};

export default function FundHeader({
  name,
  isin,
  nav,
  currency,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <AppText variant="heading">
        {name}
      </AppText>

      <AppText variant="caption">
        {isin}
      </AppText>

      <AppText
        variant="title"
        style={styles.nav}
      >
        {formatCurrency(nav, currency)}
      </AppText>
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.lg,
  },

  nav: {
    marginTop: spacing.md,
  },
});