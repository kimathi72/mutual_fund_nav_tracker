import AppScreen from "@/components/common/AppScreen";

import {
  DashboardHeader,
  KPIGrid,
  PortfolioHealthCard,
  ExecutiveBriefingCard,
  FundCarousel,
  TopMoversSection,
  KPITrendCard,
} from "@/components/dashboard";

import { useDashboard } from "@/hooks/useDashboard";

export default function DashboardScreen() {

  const { data, isLoading } = useDashboard();
  const sparkline = [
  98.2,
  99.4,
  100.5,
  101.7,
  102.8,
  103.4,
  102.9,
  104.1,
];
  console.log(data)
  if (isLoading || !data) {
    return <AppScreen />;
  }

  return (
    <AppScreen>

      <DashboardHeader
        reportDate={data.summary.report_date}
      />
      {data.briefing ? (
        <ExecutiveBriefingCard briefing={data.briefing} />
      ) : null}
      <FundCarousel
        funds={data.funds}
      />
      <PortfolioHealthCard
        insight={data.portfolio_insight}
      />
      <KPIGrid
        summary={data.summary}
      />
      
      <KPITrendCard
          title="Portfolio Return"
          value="+5.52%"
          trend={sparkline}
      />
  




      <TopMoversSection
        rankings={data.rankings}
      />


    </AppScreen>
  );
}