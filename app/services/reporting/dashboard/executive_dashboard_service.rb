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

          funds: fund_reports
        }
      end

      private

      def fund_reports
        MutualFund
          .active
          .includes(
            :daily_navs,
            :forecasts
          )
          .order(:name)
          .map do |fund|

            {
              fund_id: fund.id,
              isin: fund.isin,
              fund_name: fund.name,

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
                  .call
            }

          end
      end
    end
  end
end