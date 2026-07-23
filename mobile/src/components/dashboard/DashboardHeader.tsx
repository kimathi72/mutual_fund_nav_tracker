import React from "react";
import { StyleSheet, View } from "react-native";

import AppText from "@/components/common/AppText";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

import formatDate from "@/utils/formatDate";

interface Props {
  reportDate: string;
  generatedAt?: string;
  totalFunds?: number;
  portfolioHealth?: string;
}

export default function DashboardHeader({
  reportDate,
  generatedAt,
  totalFunds,
  portfolioHealth,
}: Props) {
  const hour = new Date().getHours();

  const greeting =
    hour < 12
      ? "Good Morning"
      : hour < 18
      ? "Good Afternoon"
      : "Good Evening";

  return (
    <View style={styles.container}>
      <AppText
        variant="caption"
        color={colors.subtitle}
      >
        {greeting}
      </AppText>

      <AppText
        variant="title"
        style={styles.title}
      >
        Executive Dashboard
      </AppText>

      <AppText
        variant="body"
        color={colors.subtitle}
      >
        Portfolio Overview
      </AppText>

      <View style={styles.metaRow}>
        <MetaItem
          label="Report"
          value={formatDate(reportDate)}
        />

        {generatedAt ? (
          <MetaItem
            label="Updated"
            value={formatDate(generatedAt)}
          />
        ) : null}

        {typeof totalFunds === "number" ? (
          <MetaItem
            label="Funds"
            value={String(totalFunds)}
          />
        ) : null}
      </View>

      {portfolioHealth ? (
        <View style={styles.statusChip}>
          <AppText
            variant="caption"
            style={styles.statusText}
          >
            Portfolio Health • {portfolioHealth}
          </AppText>
        </View>
      ) : null}
    </View>
  );
}

function MetaItem({
  label,
  value,
}: {
  label: string;
  value: string;
}) {
  return (
    <View style={styles.metaItem}>
      <AppText
        variant="caption"
        color={colors.subtitle}
      >
        {label}
      </AppText>

      <AppText variant="body">
        {value}
      </AppText>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginBottom: spacing.xl,
    paddingHorizontal: spacing.md,
  },

  title: {
    marginTop: spacing.xs,
  },

  metaRow: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginTop: spacing.lg,
  },

  metaItem: {
    flex: 1,
  },

  statusChip: {
    alignSelf: "flex-start",
    marginTop: spacing.lg,
    backgroundColor: colors.primary,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderRadius: 20,
  },

  statusText: {
    color: "#FFFFFF",
    fontWeight: "700",
  },
});