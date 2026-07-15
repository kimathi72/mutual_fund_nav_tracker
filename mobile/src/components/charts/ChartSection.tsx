import React from "react";
import { StyleSheet } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import Spacing from "@/constants/spacing";

type Props = {
  title: string;
  subtitle?: string;
  children: React.ReactNode;
};

export default function ChartSection({
  title,
  subtitle,
  children,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <AppText variant="heading">
        {title}
      </AppText>

      {subtitle && (
        <AppText
          variant="caption"
          style={styles.subtitle}
        >
          {subtitle}
        </AppText>
      )}

      {children}
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: Spacing.lg,
  },

  subtitle: {
    marginBottom: Spacing.md,
  },
});