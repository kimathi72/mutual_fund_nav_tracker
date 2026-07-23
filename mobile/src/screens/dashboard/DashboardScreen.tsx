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
import {ErrorView} from "@/components/common/ErrorView";

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

  return (
    <AppScreen>

      <DashboardHeader
        reportDate={data.summary.report_date}
        generatedAt={data.generated_at}
        totalFunds={data.summary.total_funds}
        portfolioHealth={data.portfolio_insight.portfolio_health}
      />

      {data.briefing && (
        <ExecutiveBriefingCard
          briefing={data.briefing}
        />
      )}

      <PortfolioHealthCard
        insight={data.portfolio_insight}
      />

      <KPIGrid
        summary={data.summary}
      />

      <KPITrendCard
        title="Average YTD Return"
        value={`${Number(
          data.summary.average_ytd_return
        ).toFixed(2)}%`}
        subtitle={data.portfolio_insight.market_sentiment}
        positive={
          Number(data.summary.average_ytd_return) >= 0
        }
        trend={
          data.funds[0]?.nav_history?.map(
            point => point.value
          ) ?? []
        }
      />

      <FundCarousel
        funds={data.funds}
      />

      <TopMoversSection
        rankings={data.rankings}
      />

    </AppScreen>
  );
}