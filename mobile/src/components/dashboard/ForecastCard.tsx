import React from "react";
import { StyleSheet, View } from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import spacing from "@/constants/spacing";
import colors from "@/constants/colors";

import type { ForecastReport } from "@/models/Forecast";

import formatCurrency from "@/utils/formatCurrency";
import formatPercentage from "@/utils/formatPercentage";
import trendColor from "@/utils/trendColor";

interface Props {
  forecast: ForecastReport;
  currency?: string;
}

export default function ForecastCard({
  forecast,
  currency = "",
}: Props) {
  const predictions = forecast?.predictions ?? [];

  const oneDay = predictions.find(
    (prediction) => prediction.horizon === "1d",
  );

  const thirtyDay = predictions.find(
    (prediction) => prediction.horizon === "30d",
  );

  const ninetyDay = predictions.find(
    (prediction) => prediction.horizon === "90d",
  );

  const featured = thirtyDay ?? oneDay ?? ninetyDay;

  return (
    <AppCard style={styles.card}>
      <AppText variant="heading">
        Forecast Outlook
      </AppText>

      <View style={styles.rows}>
        <ForecastRow
          label="1 Day"
          forecast={oneDay}
        />

        <ForecastRow
          label="30 Days"
          forecast={thirtyDay}
        />

        <ForecastRow
          label="90 Days"
          forecast={ninetyDay}
        />
      </View>

      {featured ? (
        <>
          <View style={styles.divider} />

          <AppText
            variant="caption"
            color={colors.subtitle}
          >
            Recommended Action
          </AppText>

          <AppText
            variant="heading"
            style={styles.recommendation}
          >
            {featured.recommendation || "--"}
          </AppText>

          <AppText
            variant="caption"
            color={colors.subtitle}
            style={styles.targetLabel}
          >
            Target NAV
          </AppText>

          <AppText variant="heading">
            {featured.predicted_nav != null
              ? formatCurrency(
                  featured.predicted_nav,
                  currency,
                )
              : "--"}
          </AppText>
        </>
      ) : (
        <AppText
          variant="caption"
          color={colors.subtitle}
          style={styles.empty}
        >
          No forecast data available.
        </AppText>
      )}
    </AppCard>
  );
}

interface ForecastRowProps {
  label: string;
  forecast?: ForecastReport["predictions"][number];
}

function ForecastRow({
  label,
  forecast,
}: ForecastRowProps) {
  if (!forecast) {
    return (
      <View style={styles.row}>
        <AppText variant="body">
          {label}
        </AppText>

        <AppText
          variant="body"
          color={colors.subtitle}
        >
          --
        </AppText>
      </View>
    );
  }

  const expectedReturn =
    forecast.expected_return_pct;

  return (
    <View style={styles.row}>
      <AppText variant="body">
        {label}
      </AppText>

      <AppText
        variant="body"
        style={{
          color: trendColor(forecast.trend),
          fontWeight: "600",
        }}
      >
        {expectedReturn != null
          ? formatPercentage(expectedReturn)
          : "--"}
      </AppText>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    marginHorizontal: spacing.md,
    marginBottom: spacing.md,
  },

  rows: {
    marginTop: spacing.md,
    gap: spacing.sm,
  },

  row: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    paddingVertical: spacing.xs,
  },

  divider: {
    marginVertical: spacing.lg,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: colors.border,
  },

  recommendation: {
    marginTop: spacing.xs,
  },

  targetLabel: {
    marginTop: spacing.md,
  },

  empty: {
    marginTop: spacing.md,
  },
});
