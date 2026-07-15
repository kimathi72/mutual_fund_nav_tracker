import { ScrollView, StyleSheet } from "react-native";

import { useDashboard } from "@/hooks/useDashboard";

import  AppScreen from "@/components/common/AppScreen";
import  AppText  from "@/components/common/AppText";

import  spacing  from "@/constants/spacing";

export default function ExecutiveBriefingScreen() {

  const { data } = useDashboard();

  if (!data) {
    return null;
  }

  return (
    <AppScreen>

      <ScrollView
        contentContainerStyle={styles.container}
      >

        <AppText
          size={28}
          weight="bold"
        >
          Executive Briefing
        </AppText>

        <AppText
          variant="caption"
        >
          {data.briefing.provider} • {data.briefing.model}
        </AppText>

        <AppText
          style={styles.body}
        >
          {data.briefing.briefing}
        </AppText>

      </ScrollView>

    </AppScreen>
  );
}

const styles = StyleSheet.create({

  container: {
    padding: spacing.lg,
  },

  body: {
    marginTop: spacing.xl,
    lineHeight: 28,
  },

});