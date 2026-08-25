# frozen_string_literal: true

module Api
  module V1
    class RankingsController < ApplicationController
      def index
        dashboard_data =
          Reporting::Dashboard::DashboardDataLoaderService.call

        funds =
          build_funds(dashboard_data)

        rankings =
          Reporting::Ranking::RankingReportService.call(
            report_date: dashboard_data.report_date,
            funds: funds
          )

        render json:
          RankingSerializer.new(rankings).as_json
      end

      private

      def build_funds(dashboard_data)
        dashboard_data.funds.map do |fund|

          performance =
            Reporting::Performance::PerformanceReportService.call(
              fund: fund
            )

          risk =
            Reporting::Risk::RiskReportService.call(
              fund: fund
            )

          forecast =
            Reporting::Forecast::ForecastReportService.call(
              fund: fund
            )

          insight =
            Reporting::Insights::ExecutiveInsightService.call(
              fund: fund,
              forecast_report: forecast
            )

          FundSummary.new(
            fund_id: fund.id,
            fund_name: fund.name,
            isin: fund.isin,

            nav: performance.latest_nav,
            currency: fund.currency,

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
      end
    end
  end
end