import { useEffect, useState } from "react";

import {
  ScrollView,
  Text,
  StyleSheet,
  View,
  ActivityIndicator
} from "react-native";

import { useLocalSearchParams } from "expo-router";

import api from "../../api/client";

type Fund = {
  id: number;
  name: string;
  isin: string;

  nav: string | null;
  nav_date: string | null;

  performance: {
    daily: number | null;
    weekly: number | null;
    monthly: number | null;
    ytd: number | null;
  };

  risk: {
    volatility: number | null;
    drawdown: number | null;
  };

  moving_averages: {
    ma7: number | null;
    ma30: number | null;
  };

  forecast: {
    predicted_nav: string | null;
    target_date: string |null;
    confidence: number | null;
  } | null;
};

export default function FundDetails() {

  const { id } = useLocalSearchParams();

  const [fund, setFund] = useState<Fund | null>(null);

  useEffect(() => {

    api
      .get(`/funds/${id}`)
      .then(res => {
        console.log("Fund details response:", res.data);
        setFund(res.data.data);
      });

  }, []);

  if (!fund) {
    return <ActivityIndicator style={{ marginTop: 80 }} />;
  }

  return (

    <ScrollView style={styles.container}>

      <Text style={styles.title}>
        {fund.name}
      </Text>

      <Text style={styles.subtitle}>
        {fund.isin}
      </Text>

      <View style={styles.card}>

        <Text style={styles.heading}>
          Current NAV
        </Text>

        <Text style={styles.value}>
          {fund.nav ?? "--"}
        </Text>

        <Text>
          {fund.nav_date ?? "--"}
        </Text>

      </View>

      <View style={styles.card}>

        <Text style={styles.heading}>
          Performance
        </Text>

        <Text>Daily: {fund.performance.daily ?? "--"}%</Text>

        <Text>Weekly: {fund.performance.weekly ?? "--"}%</Text>

        <Text>Monthly: {fund.performance.monthly ?? "--"}%</Text>

        <Text>YTD: {fund.performance.ytd ?? "--"}%</Text>

      </View>

      <View style={styles.card}>

        <Text style={styles.heading}>
          Risk
        </Text>

        <Text>
          Volatility:
          {" "}
          {fund.risk.volatility ?? "--"}
        </Text>

        <Text>
          Drawdown:
          {" "}
          {fund.risk.drawdown ?? "--"}
        </Text>

      </View>

      <View style={styles.card}>

        <Text style={styles.heading}>
          Moving Averages
        </Text>

        <Text>
          MA(7):
          {" "}
          {fund.moving_averages.ma7 ?? "--"}
        </Text>

        <Text>
          MA(30):
          {" "}
          {fund.moving_averages.ma30 ?? "--"}
        </Text>

      </View>

      <View style={styles.card}>

        <Text style={styles.heading}>
          AI Forecast
        </Text>

        <Text>
          Predicted NAV:
          {" "}
          {fund.forecast?.predicted_nav ?? "--"}
        </Text>

        <Text>
          Target Date:
          {" "}
          {fund.forecast?.target_date ?? "--"}
        </Text>

        <Text>
          Confidence:
          {" "}
          {fund.forecast?.confidence ?? "--"}
        </Text>

      </View>

    </ScrollView>

  );

}

const styles = StyleSheet.create({

  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
    padding: 16
  },

  title: {
    fontSize: 24,
    fontWeight: "bold"
  },

  subtitle: {
    color: "#666",
    marginBottom: 20
  },

  card: {
    backgroundColor: "#fff",
    padding: 18,
    borderRadius: 12,
    marginBottom: 16
  },

  heading: {
    fontWeight: "bold",
    fontSize: 16,
    marginBottom: 8
  },

  value: {
    fontSize: 32,
    fontWeight: "bold",
    color: "#1565c0"
  }

});