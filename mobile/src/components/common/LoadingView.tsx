import React from "react";
import {
  ActivityIndicator,
  StyleSheet,
  View,
} from "react-native";

import AppText from "./AppText";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

type Props = {
  message?: string;
};

export default function LoadingView({
  message = "Loading...",
}: Props) {
  return (
    <View style={styles.container}>
      <ActivityIndicator
        size="large"
        color={colors.primary}
      />

      <AppText style={styles.text}>
        {message}
      </AppText>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    minHeight: 300,
    justifyContent: "center",
    alignItems: "center",
    padding: spacing.lg,
  },

  text: {
    marginTop: spacing.md,
    color: colors.secondary,
  },
});