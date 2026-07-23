import React from "react";
import { StyleSheet, View } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import { SparkLine } from "@/components/charts";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

type Props = {
  title: string;

  value: string;

  trend: number[];

  subtitle?: string;

  positive?: boolean;
};

export default function KPITrendCard({
  title,
  value,
  trend,
  subtitle,
  positive = true,
}: Props) {
  const trendColor = positive
    ? colors.success
    : colors.danger;

  const trendIcon = positive
    ? "▲"
    : "▼";

  return (
    <AppCard style={styles.card}>
      <View style={styles.header}>
        <View style={{ flex: 1 }}>
          <AppText
            variant="caption"
            color={colors.subtitle}
          >
            {title}
          </AppText>

          <AppText
            variant="title"
            style={styles.value}
          >
            {value}
          </AppText>

          {subtitle ? (
            <View style={styles.trendRow}>
              <AppText
                style={[
                  styles.trend,
                  {
                    color: trendColor,
                  },
                ]}
              >
                {trendIcon} {subtitle}
              </AppText>
            </View>
          ) : null}
        </View>

        <View style={styles.sparkContainer}>
          <SparkLine
            data={trend.map((v, index) => ({
              date: String(index),
              value: v,
            }))}
          />
        </View>
      </View>
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.lg,
    paddingVertical: spacing.lg,
  },

  header: {
    flexDirection: "row",
    alignItems: "center",
  },

  value: {
    marginTop: spacing.xs,
    fontSize: 34,
    fontWeight: "700",
  },

  trendRow: {
    marginTop: spacing.sm,
  },

  trend: {
    fontSize: 14,
    fontWeight: "600",
  },

  sparkContainer: {
    width: 130,
    alignItems: "center",
    justifyContent: "center",
  },
});