import { Pressable, StyleSheet, View } from "react-native";
import { useRouter } from "expo-router";

import { ExecutiveBriefing } from "@/models/ExecutiveBriefing";

import  AppCard  from "@/components/common/AppCard";
import  AppText  from "@/components/common/AppText";
import  colors  from "@/constants/colors";
import  spacing  from "@/constants/spacing";

type Props = {
  briefing: ExecutiveBriefing;
};

export default function ExecutiveBriefingCard({
  briefing,
}: Props) {
  const router = useRouter();

  if (!briefing) {
    return null;
  }

  const preview =
    briefing.briefing.length > 260
      ? briefing.briefing.substring(0, 260) + "..."
      : briefing.briefing;

  return (
    <AppCard>

      <View style={styles.header}>

        <View>
          <AppText
            size={20}
            weight="bold"
          >
            🤖 Executive AI Briefing
          </AppText>

          <AppText
            variant="caption"
            style={styles.provider}
          >
            {briefing.provider.toUpperCase()} • {briefing.model}
          </AppText>
        </View>

        <View
          style={[
            styles.status,
            briefing.status === "success"
              ? styles.success
              : styles.error,
          ]}
        >
          <AppText style={styles.statusText}>
            {briefing.status}
          </AppText>
        </View>

      </View>

      <View style={styles.divider} />

      <AppText style={styles.preview}>
        {preview}
      </AppText>

      <Pressable
        style={styles.button}
        onPress={() =>
          router.push("/briefing")
        }
      >
        <AppText
          weight="bold"
          style={styles.buttonText}
        >
          Read Full Briefing →
        </AppText>
      </Pressable>

    </AppCard>
  );
}

const styles = StyleSheet.create({

  header: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },

  provider: {
    marginTop: spacing.xs,
    color: colors.secondaryText,
  },

  divider: {
    marginVertical: spacing.lg,
    height: 1,
    backgroundColor: colors.border,
  },

  preview: {
    lineHeight: 24,
    color: colors.text,
  },

  button: {
    marginTop: spacing.xl,
    alignSelf: "flex-start",
  },

  buttonText: {
    color: colors.primary,
  },

  status: {
    borderRadius: 18,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
  },

  success: {
    backgroundColor: colors.success,
  },

  error: {
    backgroundColor: colors.danger,
  },

  statusText: {
    color: "#fff",
    fontWeight: "700",
    textTransform: "capitalize",
  },

});