# frozen_string_literal: true

module Reporting
  module Dashboard
    class ExecutiveDashboardService < ApplicationService
      def call
        {
          generated_at: Time.current,

          summary:
            Reporting::Portfolio::PortfolioSummaryService
              .new
              .call,

          rankings:
            Reporting::Ranking::RankingReportService
              .new
              .call,

          funds:
            fund_reports
        }
      end

      private

      def fund_reports
        MutualFund
          .includes(
            :daily_navs,
            :forecasts
          )
          .where(active: true)
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

            insight:
              Reporting::Insights::ExecutiveInsightService
                .new(fund: fund)
                .call,

            intelligence:
              Reporting::Intelligence::PortfolioIntelligenceService
                .new
                .call,
          }

        end
      end
    end
  end
end