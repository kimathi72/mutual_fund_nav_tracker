import AppScreen from "@/components/common/AppScreen";

import {
  DashboardHeader,
  KPIGrid,
  PortfolioHealthCard,
  ExecutiveBriefingCard,
  FundCarousel,
  TopMoversSection,
} from "@/components/dashboard";

import { useDashboard } from "@/hooks/useDashboard";

export default function DashboardScreen() {

  const { data, isLoading } = useDashboard();

  if (isLoading || !data) {
    return <AppScreen />;
  }

  return (
    <AppScreen>

      <DashboardHeader
        reportDate={data.summary.report_date}
      />

      <KPIGrid
        summary={data.summary}
      />

      <PortfolioHealthCard
        insight={data.portfolio_insight}
      />

      {data.briefing ? (
        <ExecutiveBriefingCard briefing={data.briefing} />
      ) : null}

      <TopMoversSection
        rankings={data.rankings}
      />

      <FundCarousel
        funds={data.funds}
      />

    </AppScreen>
  );
}