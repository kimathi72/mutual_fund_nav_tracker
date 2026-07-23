import React from "react";
import {
  ScrollView,
  StyleSheet,
  View,
} from "react-native";

import { useDashboard } from "@/hooks/useDashboard";

import AppScreen from "@/components/common/AppScreen";
import LoadingView from "@/components/common/LoadingView";
import { ErrorView } from "@/components/common/ErrorView";
import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

import formatDate from "@/utils/formatDate";

export default function ExecutiveBriefingScreen() {
  const {
    data,
    isLoading,
    isError,
    refetch,
  } = useDashboard();

  if (isLoading) {
    return <LoadingView />;
  }

  if (isError || !data?.briefing) {
    return (
      <ErrorView
        message="Unable to load executive briefing."
        onRetry={() => refetch()}
      />
    );
  }

  const briefing = data.briefing;

  return (
    <AppScreen>
      <ScrollView
        contentContainerStyle={styles.container}
      >
        <AppText variant="title">
          Executive Briefing
        </AppText>

        <AppText
          variant="caption"
          color={colors.subtitle}
        >
          AI Generated Portfolio Report
        </AppText>

        <AppCard style={styles.metaCard}>
          <MetaRow
            label="Provider"
            value={briefing.provider}
          />

          <MetaRow
            label="Model"
            value={briefing.model}
          />

          <MetaRow
            label="Status"
            value={briefing.status}
          />

          <MetaRow
            label="Generated"
            value={formatDate(
              briefing.generated_at
            )}
          />
        </AppCard>

        <AppCard>
          <AppText
            variant="heading"
            style={styles.heading}
          >
            Executive Summary
          </AppText>

          <AppText style={styles.body}>
            {briefing.briefing}
          </AppText>
        </AppCard>
      </ScrollView>
    </AppScreen>
  );
}

function MetaRow({
  label,
  value,
}: {
  label: string;
  value: string;
}) {
  return (
    <View style={styles.metaRow}>
      <AppText
        variant="caption"
        color={colors.subtitle}
      >
        {label}
      </AppText>

      <AppText>{value}</AppText>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    padding: spacing.lg,
    gap: spacing.lg,
  },

  metaCard: {
    gap: spacing.md,
  },

  metaRow: {
    flexDirection: "row",
    justifyContent: "space-between",
  },

  heading: {
    marginBottom: spacing.md,
  },

  body: {
    lineHeight: 28,
    fontSize: 16,
  },
});