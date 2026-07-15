import {
  Text,
  TextProps,
  StyleSheet,
  TextStyle,
} from "react-native";

import Typography from "@/constants/typography";
import Colors from "@/constants/colors";

interface Props extends TextProps {
  variant?:
    | "title"
    | "heading"
    | "subheading"
    | "body"
    | "caption";

  color?: string;

  weight?:
    | "400"
    | "500"
    | "600"
    | "700"
    | "bold"
    | "normal";

  align?: TextStyle["textAlign"];
}

export default function AppText({
  variant = "body",
  color,
  weight,
  align,
  style,
  ...props
}: Props) {
  return (
    <Text
      {...props}
      style={[
        styles.base,
        styles[variant],
        color && { color },
        weight && { fontWeight: weight },
        align && { textAlign: align },
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

  subheading: {
    fontSize: Typography.subheading,
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