import React from "react";
import {
  Text,
  TextProps,
  StyleSheet,
  TextStyle,
} from "react-native";

import Colors from "@/constants/colors";
import Typography from "@/constants/typography";

interface Props extends TextProps {
  variant?: "title" | "heading" | "body" | "caption";

  size?: number;

  weight?:
    | "400"
    | "500"
    | "600"
    | "700"
    | "normal"
    | "bold";

  color?: string;
}

export default function AppText({
  variant = "body",
  size,
  weight,
  color,
  style,
  ...props
}: Props) {
  return (
    <Text
      {...props}
      style={[
        styles.base,
        styles[variant],
        size !== undefined ? { fontSize: size } : undefined,
        weight ? { fontWeight: weight as TextStyle["fontWeight"] } : undefined,
        color ? { color } : undefined,
        style,
      ]}
    />
  );
}

const styles = StyleSheet.create({
  base: {
    color: Colors.text,
  },

  title: {
    fontSize: Typography.title,
    fontWeight: "700",
  },

  heading: {
    fontSize: Typography.heading,
    fontWeight: "600",
  },

  body: {
    fontSize: Typography.body,
  },

  caption: {
    fontSize: Typography.caption,
    color: Colors.subtitle,
  },
});