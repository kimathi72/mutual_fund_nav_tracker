import React from "react";
import { FlatList, StyleSheet } from "react-native";

import type { FundSummary } from "@/models/FundSummary";

import FundCard from "./FundCard";

import spacing from "@/constants/spacing";

interface Props {
  funds: FundSummary[];
}

export default function FundCarousel({
  funds,
}: Props) {
  return (
    <FlatList
      horizontal
      data={funds}
      keyExtractor={(item) =>
        item.isin
      }
      renderItem={({ item }) => (
        <FundCard fund={item} />
      )}
      showsHorizontalScrollIndicator={false}
      contentContainerStyle={styles.list}

      initialNumToRender={5}
      maxToRenderPerBatch={5}
      windowSize={5}
      removeClippedSubviews
    />
  );
}

const styles = StyleSheet.create({
  list: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.md,
    gap: spacing.md,
  },
});