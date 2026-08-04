import React from "react";
import {
  StyleSheet,
  View,
} from "react-native";

import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

import Colors from "@/constants/colors";
import Spacing from "@/constants/spacing";

type Props = {

  title: string;

  subtitle?: string;

  rightLabel?: string;

  children: React.ReactNode;

};

export default function ChartCard({

  title,

  subtitle,

  rightLabel,

  children,

}: Props) {

  return (

    <AppCard style={styles.card}>

      <View style={styles.header}>

        <View>

          <AppText variant="heading">

            {title}

          </AppText>

          {subtitle && (

            <AppText variant="caption">

              {subtitle}

            </AppText>

          )}

        </View>

        {rightLabel && (

          <AppText

            variant="caption"

            style={styles.right}

          >

            {rightLabel}

          </AppText>

        )}

      </View>

      {children}

    </AppCard>

  );

}

const styles = StyleSheet.create({

  card: {

    marginVertical: Spacing.lg,

  },

  header: {

    flexDirection: "row",

    justifyContent: "space-between",

    alignItems: "center",

    marginBottom: Spacing.md,

  },

  right: {

    color: Colors.primary,

    fontWeight: "600",

  },

});