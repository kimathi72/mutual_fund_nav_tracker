// src/components/dashboard/KPICard.tsx

import { View, StyleSheet } from "react-native";
import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";
import  colors  from "@/constants/colors";
import  spacing  from "@/constants/spacing";

type Props = {
  title: string;
  value: string | number;
  subtitle?: string;
};

export default function KPICard({
  title,
  value,
  subtitle,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <AppText style={styles.value}>
        {value}
      </AppText>

      <AppText style={styles.title}>
        {title}
      </AppText>

      {subtitle && (
        <AppText style={styles.subtitle}>
          {subtitle}
        </AppText>
      )}
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
    fontSize: 28,
    fontWeight: "700",
    color: colors.primary,
  },

  title: {
    marginTop: spacing.sm,
    fontSize: 14,
    color: colors.text,
  },

  subtitle: {
    marginTop: 4,
    fontSize: 12,
    color: colors.muted,
  },
});