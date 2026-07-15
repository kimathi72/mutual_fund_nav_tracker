import React from "react";
import { ScrollView } from "react-native";

import AppScreen from "@/components/common/AppScreen";
import SectionHeader from "@/components/common/SectionHeader";
import FundCard from "@/components/dashboard/FundCard";

import { useDashboard } from "@/hooks/useDashboard";

export default function RankingScreen() {
  const { data, isLoading } = useDashboard();

  if (isLoading || !data) {
    return <AppScreen />;
  }

  return (
    <AppScreen>
      <ScrollView showsVerticalScrollIndicator={false}>
        <SectionHeader
          title="Portfolio Rankings"
          subtitle={data.summary.report_date}
        />

        <SectionHeader title="Top YTD Return" />

        {data.rankings.top_ytd.map((fund) => (
          <FundCard
            key={fund.fund_id}
            ranking={fund}
          />
        ))}

        <SectionHeader title="Highest Risk" />

        {data.rankings.highest_risk.map((fund) => (
          <FundCard
            key={`risk-${fund.fund_id}`}
            ranking={fund}
          />
        ))}

        <SectionHeader title="Largest Drawdown" />

        {data.rankings.largest_drawdown.map((fund) => (
          <FundCard
            key={`dd-${fund.fund_id}`}
            ranking={fund}
          />
        ))}
      </ScrollView>
    </AppScreen>
  );
}