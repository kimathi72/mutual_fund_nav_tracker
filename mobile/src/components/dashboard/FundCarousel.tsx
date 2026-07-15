import React from "react";
import { FlatList, StyleSheet } from "react-native";

import  ExecutiveFund  from "@/models/ExecutiveFund";

import FundCard from "./FundCard";

import spacing from "@/constants/spacing";

type Props = {
  funds: ExecutiveFund[];
};

export default function FundCarousel({
  funds,
}: Props) {
  return (
    <FlatList
      horizontal
      data={funds}
      keyExtractor={(item) =>
        item.performance.isin
      }
      renderItem={({ item }) => (
        <FundCard fund={item} />
      )}
      showsHorizontalScrollIndicator={false}
      contentContainerStyle={styles.list}
    />
  );
}

const styles = StyleSheet.create({
  list: {
    paddingHorizontal: spacing.md,
  },
});