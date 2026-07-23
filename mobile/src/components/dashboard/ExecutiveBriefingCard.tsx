import React from "react";
import { StyleSheet, View } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

import type { ExecutiveBriefing } from "@/models/ExecutiveBriefing";

import formatDate from "@/utils/formatDate";

import statusColor from "@/utils/statusColor";

interface Props {
  briefing: ExecutiveBriefing;
}

export default function ExecutiveBriefingCard({
  briefing,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <View style={styles.header}>
        <AppText variant="heading">
          Executive Briefing
        </AppText>

        <View style={[styles.badge, { backgroundColor: statusColor(briefing.status) }]}>
          <AppText
            variant="caption"
            color="#fff"
          >
            {briefing.status}
          </AppText>
        </View>
      </View>

      <AppText
        variant="body"
        style={styles.body}
      >
        {briefing.error ??
          briefing.briefing}
      </AppText>

      <View style={styles.footer}>
        <AppText
          variant="caption"
          color={colors.subtitle}
        >
          {briefing.provider}
        </AppText>

        <AppText
          variant="caption"
          color={colors.subtitle}
        >
          {briefing.model}
        </AppText>

        <AppText
          variant="caption"
          color={colors.subtitle}
        >
          {formatDate(
            briefing.generated_at
          )}
        </AppText>
      </View>
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginHorizontal: spacing.md,
    marginBottom: spacing.md,
  },

  header: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },

  badge: {
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: 20,
  },

  body: {
    marginTop: spacing.md,
    lineHeight: 22,
  },

  footer: {
    marginTop: spacing.lg,
    flexDirection: "row",
    justifyContent: "space-between",
  },
});