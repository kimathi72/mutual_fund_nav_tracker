import React, { ReactNode } from "react";
import { View, StyleSheet } from "react-native";

import AppText from "../../common/AppText";
import AppCard from "../../common/AppCard";

interface Props {
  title: string;
  children: ReactNode;
}

export default function ExecutiveSection({
  title,
  children,
}: Props) {
  return (
    <AppCard>
      <View style={styles.container}>
        <AppText variant="title">
          {title}
        </AppText>

        <View style={styles.content}>
          {children}
        </View>
      </View>
    </AppCard>
  );
}

const styles = StyleSheet.create({
  container: {
    gap: 12,
  },

  content: {
    gap: 8,
  },
});