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

import LoadingView from "@/components/common/LoadingView";
import { ErrorView } from "@/components/common/ErrorView";

import { useDashboard } from "@/hooks/useDashboard";

export default function DashboardScreen() {
  const {
    data,
    isLoading,
    isError,
    refetch,
  } = useDashboard();

  if (isLoading) {
    return <LoadingView />;
  }

  if (isError || !data) {
    return (
      <ErrorView
        message="Unable to load dashboard."
        onRetry={refetch}
      />
    );
  }

  const {
    generated_at,
    summary,
    rankings,
    portfolio_insight: insight,
    briefing,
    funds,
  } = data;

  return (
    <AppScreen>
      <DashboardHeader
        reportDate={summary.report_date}
        generatedAt={generated_at}
        totalFunds={summary.total_funds}
        portfolioHealth={insight.portfolio_health}
      />
      <FundCarousel
        funds={funds}
      />

      {briefing && (
        <ExecutiveBriefingCard
          briefing={briefing}
        />
      )}

      <PortfolioHealthCard
        insight={insight}
      />

      <KPIGrid
        summary={summary}
      />

      <KPITrendCard
        title="Average YTD Return"
        value={`${Number(
          summary.average_ytd_return
        ).toFixed(2)}%`}
        subtitle={insight.market_sentiment}
        positive={
          Number(summary.average_ytd_return) >= 0
        }
      />


      <TopMoversSection
        rankings={rankings}
      />
    </AppScreen>
  );
}