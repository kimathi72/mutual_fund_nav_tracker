import React from "react";
import { StyleSheet } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

interface Props {
  title: string;
  value: string | number;
  subtitle?: string;
}

export default function KPICard({
  title,
  value,
  subtitle,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <AppText
        variant="heading"
        style={styles.value}
      >
        {value}
      </AppText>

      <AppText
        variant="body"
        style={styles.title}
      >
        {title}
      </AppText>

      {subtitle ? (
        <AppText
          variant="caption"
          color={colors.subtitle}
        >
          {subtitle}
        </AppText>
      ) : null}
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    flex: 1,
    minHeight: 110,
    justifyContent: "center",
    padding: spacing.lg,
  },

  value: {
    color: colors.primary,
    marginBottom: spacing.xs,
  },

  title: {
    fontWeight: "600",
  },
});