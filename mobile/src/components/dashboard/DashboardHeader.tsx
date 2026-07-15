import { StyleSheet, View } from "react-native";

import AppText from "@/components/common/AppText";

import  colors  from "@/constants/colors";
import  spacing  from "@/constants/spacing";

type Props = {
  reportDate: string;
};

export default function DashboardHeader({
  reportDate,
}: Props) {
  return (
    <View style={styles.container}>

      <AppText
        size={30}
        weight="bold"
      >
        Executive Dashboard
      </AppText>

      <AppText
        style={styles.date}
      >
        Portfolio Overview • {reportDate}
      </AppText>

    </View>
  );
}

const styles = StyleSheet.create({

  container: {
    marginBottom: spacing.xl,
  },

  date: {
    marginTop: spacing.sm,
    color: colors.secondaryText,
  },

});