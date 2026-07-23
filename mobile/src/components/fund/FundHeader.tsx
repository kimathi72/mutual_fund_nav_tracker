import React from "react";
import { StyleSheet, View } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

import formatCurrency from "@/utils/formatCurrency";
import formatDate from "@/utils/formatDate";

interface Props {
  name: string;
  isin: string;

  nav: number;

  currency: string;

  navDate?: string;
}

export default function FundHeader({
  name,
  isin,
  nav,
  currency,
  navDate,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <View style={styles.topRow}>
        <View style={styles.titleContainer}>
          <AppText
            variant="title"
            style={styles.title}
          >
            {name}
          </AppText>

          <AppText
            variant="caption"
            color={colors.subtitle}
          >
            {isin}
          </AppText>
        </View>

        <View style={styles.currencyChip}>
          <AppText
            variant="caption"
            style={styles.currencyText}
          >
            {currency}
          </AppText>
        </View>
      </View>

      <View style={styles.navSection}>
        <AppText
          variant="caption"
          color={colors.subtitle}
        >
          Current NAV
        </AppText>

        <AppText
          variant="title"
          style={styles.nav}
        >
          {formatCurrency(nav, currency)}
        </AppText>

        {navDate && (
          <AppText
            variant="caption"
            color={colors.subtitle}
          >
            Updated {formatDate(navDate)}
          </AppText>
        )}
      </View>
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.lg,
  },

  topRow: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "flex-start",
  },

  titleContainer: {
    flex: 1,
    marginRight: spacing.md,
  },

  title: {
    marginBottom: spacing.xs,
  },

  currencyChip: {
    backgroundColor: colors.primary,
    borderRadius: 18,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
  },

  currencyText: {
    color: "#FFFFFF",
    fontWeight: "700",
  },

  navSection: {
    marginTop: spacing.xl,
  },

  nav: {
    marginVertical: spacing.sm,
    fontSize: 36,
    fontWeight: "700",
  },
});