# frozen_string_literal: true

module Reporting
  module Dashboard
    class ExecutiveDashboardService < ApplicationService
      def call
        summary =
          Reporting::Portfolio::PortfolioSummaryService
            .new
            .call

        rankings =
          Reporting::Ranking::RankingReportService
            .new
            .call

        portfolio_insight =
          Reporting::Insights::PortfolioExecutiveInsightService
            .new
            .call

        funds = fund_reports

        briefing =
          Llm::ExecutiveBriefingService.new(
            summary: summary,
            portfolio_insights: portfolio_insight,
            fund_insights: funds.map { |f| f[:executive_insight] }
          ).call

        ExecutiveDashboard.new(
          generated_at: Time.current,
          summary: summary,
          rankings: rankings,
          portfolio_insight: portfolio_insight,
          funds: funds,
          briefing: briefing
        )
      end

      private

      def fund_reports
        MutualFund
          .active
          .includes(:daily_navs, :forecasts)
          .order(:name)
          .map do |fund|
            {
              performance:
                Reporting::Performance::PerformanceReportService
                  .new(fund: fund)
                  .call,

              risk:
                Reporting::Risk::RiskReportService
                  .new(fund: fund)
                  .call,

              forecast:
                Reporting::Forecast::ForecastReportService
                  .new(fund: fund)
                  .call,

              executive_insight:
                Reporting::Insights::ExecutiveInsightService
                  .new(fund: fund)
                  .call
            }
          end
      end
    end
  end
end