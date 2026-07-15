import React from "react";
import { View, StyleSheet } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import Colors from "@/constants/colors";
import Spacing from "@/constants/spacing";

type Props = {
  title: string;
  subtitle?: string;
  children: React.ReactNode;
};

export default function ChartCard({
  title,
  subtitle,
  children,
}: Props) {
  return (
    <AppCard style={styles.card}>
      <View style={styles.header}>
        <AppText variant="heading">
          {title}
        </AppText>

        {subtitle && (
          <AppText variant="caption">
            {subtitle}
          </AppText>
        )}
      </View>

      {children}
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginVertical: Spacing.lg,
  },

  header: {
    marginBottom: Spacing.md,
  },
});