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
  const oneDay =
    forecast.forecasts.find(
      f => f.horizon === "1d"
    );

  const thirtyDay =
    forecast.forecasts.find(
      f => f.horizon === "30d"
    );

  const ninetyDay =
    forecast.forecasts.find(
      f => f.horizon === "90d"
    );

  const featured =
    thirtyDay ??
    oneDay ??
    ninetyDay;

  return (
    <AppCard>

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

      {featured && (
        <>
          <View style={styles.divider} />

          <AppText
            variant="caption"
            color={colors.subtitle}
          >
            Recommended Action
          </AppText>

          <AppText variant="heading">
            {featured.recommendation}
          </AppText>

          <AppText
            variant="caption"
            color={colors.subtitle}
          >
            Target NAV
          </AppText>

          <AppText variant="heading">
            {featured.predicted_nav != null
              ? formatCurrency(
                  featured.predicted_nav,
                  currency
                )
              : "--"}
          </AppText>
        </>
      )}

    </AppCard>
  );
}

interface ForecastRowProps {
  label: string;
  forecast?: ForecastReport["forecasts"][number];
}

function ForecastRow({
  label,
  forecast,
}: ForecastRowProps) {
  if (!forecast) {
    return (
      <View style={styles.row}>
        <AppText>{label}</AppText>
        <AppText>--</AppText>
      </View>
    );
  }

  return (
    <View style={styles.row}>
      <AppText>{label}</AppText>

      <AppText
        style={{
          color: trendColor(
            forecast.trend
          ),
        }}
      >
        {forecast.expected_return_pct != null
          ? formatPercentage(
              forecast.expected_return_pct
            )
          : "--"}
      </AppText>
    </View>
  );
}

const styles = StyleSheet.create({
  rows: {
    marginTop: spacing.md,
    gap: spacing.sm,
  },

  row: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },

  divider: {
    marginVertical: spacing.lg,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: "#ddd",
  },
});