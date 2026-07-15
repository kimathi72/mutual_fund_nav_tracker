import React from "react";
import {
  View,
  StyleSheet,
  ViewStyle,
  StyleProp,
} from "react-native";

import colors from "@/constants/colors";
import spacing from "@/constants/spacing";

type Props = {
  children: React.ReactNode;
  style?: StyleProp<ViewStyle>;
};

export default function AppCard({
  children,
  style,
}: Props) {
  return (
    <View style={[styles.card, style]}>
      {children}
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: colors.surface,
    borderRadius: 18,

    padding: spacing.lg,

    shadowColor: "#000",
    shadowOpacity: 0.08,
    shadowRadius: 12,
    shadowOffset: {
      width: 0,
      height: 4,
    },

    elevation: 3,
  },
});