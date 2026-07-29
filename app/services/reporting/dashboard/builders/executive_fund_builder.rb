# frozen_string_literal: true

module Reporting
  module Dashboard
    module Builders
      class ExecutiveFundBuilder < ApplicationService
        def initialize(fund:)
          @fund = fund
        end

        def call
          FundSummary.new(
            fund_id: fund.id,
            fund_name: fund.name,
            isin: fund.isin,

            nav: performance.latest_nav,
            currency: performance.currency,

            daily_return: performance.daily_return,
            weekly_return: performance.weekly_return,
            monthly_return: performance.monthly_return,
            ytd_return: performance.ytd_return,

            volatility: risk.volatility_30,
            drawdown: risk.drawdown,

            recommendation: insight.recommendation,
            market_outlook: insight.market_outlook,
            opportunity_score: insight.opportunity_score
          )
        end

        private

        attr_reader :fund

        def performance
          @performance ||=
            Reporting::Performance::PerformanceReportService.call(
              fund: fund
            )
        end

        def risk
          @risk ||=
            Reporting::Risk::RiskReportService.call(
              fund: fund
            )
        end

        def forecast
          @forecast ||=
            Reporting::Forecast::ForecastReportService.call(
              fund: fund
            )
        end

        def insight
          @insight ||=
            Reporting::Insights::ExecutiveInsightService.call(
              fund: fund,
              forecast_report: forecast
            )
        end
      end
    end
  end
end