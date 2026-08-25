// screens/dashboard/DashboardScreen.tsx

import React from 'react';
import {
  RefreshControl,
  ScrollView,
} from 'react-native';
import RankingTabs from '@/components/dashboard/RankingTabs';
import { useDashboard } from '../../hooks/useDashboard';

import {
  AppScreen,
  LoadingView,
  ErrorView,
} from '../../components/common';

import {
  DashboardHeader,
  KPIGrid,
  PortfolioHealthCard,
  RiskOverviewCard,
  TopPerformerCard,
  TopMoversSection,
  ExecutiveBriefingCard,
  FundCarousel,
} from '../../components/dashboard';

import {
  AreaPerformanceChart,
  VolatilityChart,
  RiskHeatMap,
} from '../../components/charts';
import RiskAnalysisSection from '@/components/dashboard/RiskAnalysisSection';

export default function DashboardScreen() {
  const {
    data,
    isPending,
    isError,
    error,
    refetch,
    isFetching,
  } = useDashboard();

  if (isPending) {
    return <LoadingView />;
  }

  if (isError || !data) {
    return (
      <ErrorView
        message={error?.message ?? 'Unable to load dashboard'}
        onRetry={refetch}
      />
    );
  }

  return (
    <AppScreen>
      <ScrollView
        refreshControl={
          <RefreshControl
            refreshing={isFetching}
            onRefresh={refetch}
          />
        }
      >
        <DashboardHeader
          reportDate={data.summary.report_date}
        />

        <FundCarousel
          funds={data.funds}
        />

        <PortfolioHealthCard
          insight={data.portfolio_insight}
        />
        <RiskAnalysisSection summary={data.summary} funds={data.funds} />

        <KPIGrid
          summary={data.summary}
        />

        {/* <RiskOverviewCard
          summary={data.summary}
        /> */}
        <RankingTabs
          rankings={data.rankings}
        />

{/* 
        <AreaPerformanceChart
          funds={data.funds}
        />

        <VolatilityChart
          funds={data.funds}
        /> */}


        {/* <TopPerformerCard
          fund={data.summary.best_performer}
        />

        <TopMoversSection
          rankings={data.rankings}
        /> */}

        <ExecutiveBriefingCard
          briefing={data.briefing}
        />
      </ScrollView>
    </AppScreen>
  );
}

