# frozen_string_literal: true

module Api
  module V1
    class ReportsController < BaseController
      def portfolio
        dashboard_data = DashboardDataLoaderService.call
        funds = build_funds(dashboard_data)

        summary =
          Reporting::Portfolio::PortfolioSummaryService.call(
            report_date: dashboard_data.report_date,
            funds: funds
          )

        render json:
          PortfolioSummarySerializer.new(summary).as_json
      end

      def rankings
        dashboard_data = DashboardDataLoaderService.call
        funds = build_funds(dashboard_data)

        rankings =
          Reporting::Ranking::RankingReportService.call(
            report_date: dashboard_data.report_date,
            funds: funds
          )

        render json:
          RankingReportSerializer.new(rankings).as_json
      end

      def performance
        fund = MutualFund.find(params[:fund_id])

        render json:
          PerformanceReportSerializer.new(
            Reporting::Performance::PerformanceReportService.call(
              fund: fund
            )
          ).as_json
      end

      def risk
        fund = MutualFund.find(params[:fund_id])

        render json:
          RiskReportSerializer.new(
            Reporting::Risk::RiskReportService.call(
              fund: fund
            )
          ).as_json
      end

      def briefing
        dashboard =
          Reporting::Dashboard::ExecutiveDashboardService.call

        render json: dashboard.briefing
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