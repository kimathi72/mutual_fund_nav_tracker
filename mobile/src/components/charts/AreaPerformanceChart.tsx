
import React, { useMemo } from "react";
import {
  StyleSheet,
  Text,
  View,
} from "react-native";

import colors from "@/constants/colors";

import type { ExecutiveFund } from "../../models/ExecutiveFund";

interface Props {
  funds: ExecutiveFund[];
}

interface PerformancePoint {
  name: string;
  value: number;
}

export default function AreaPerformanceChart({ funds }: Props) {
  const data = useMemo<PerformancePoint[]>(() => {
    return funds.map((fund) => ({
      name: fund.name,
      value: Number(fund.ytd_return) * 100,
    }));
  }, [funds]);

  if (!funds.length) {
    return null;
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>
        YTD Performance
      </Text>

      {data.map((item) => (
        <View
          key={item.name}
          style={styles.row}
        >
          <Text
            style={styles.name}
            numberOfLines={1}
          >
            {item.name}
          </Text>

          <Text
            style={[
              styles.value,
              {
                color:
                  item.value >= 0
                    ? colors.success
                    : colors.danger,
              },
            ]}
          >
            {item.value.toFixed(2)}%
          </Text>
        </View>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginHorizontal: 16,
    marginBottom: 16,
    padding: 16,
    borderRadius: 16,
    backgroundColor: "#FFFFFF",
  },

  title: {
    fontSize: 18,
    fontWeight: "700",
    marginBottom: 16,
  },

  row: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    marginBottom: 12,
  },

  name: {
    flex: 1,
    marginRight: 12,
    fontSize: 13,
    color: "#444444",
  },

  value: {
    fontSize: 14,
    fontWeight: "700",
  },
});
