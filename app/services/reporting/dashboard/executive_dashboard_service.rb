# frozen_string_literal: true

module Reporting
  module Dashboard
    class ExecutiveDashboardService < ApplicationService
      def call
        dashboard_data =
          DashboardDataLoaderService.call

        funds =
          build_funds(dashboard_data)

        summary =
          Reporting::Portfolio::PortfolioSummaryService.call(
            report_date: dashboard_data.report_date,
            funds: funds
          )

        rankings =
          Reporting::Ranking::RankingReportService.call(
            report_date: dashboard_data.report_date,
            funds: funds
          )

        portfolio_insight =
          Reporting::Insights::PortfolioExecutiveInsightService.call(
            summary: summary
          )

        briefing =
          Llm::ExecutiveBriefingService.call(
            summary: summary,
            portfolio_insights: portfolio_insight,
            funds: funds
          )

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

      def metrics(dashboard_data)
        dashboard_data.funds.filter_map do |fund|
          metric_for(
            fund,
            dashboard_data.report_date
          )
        end
      end

      def metric_for(fund, report_date)
        fund.daily_nav_metrics.find do |metric|
          metric.daily_nav.nav_date == report_date
        end
      end

      ####################################################
      # Dashboard Cards
      ####################################################

      def build_funds(dashboard_data)
        dashboard_data.funds.map do |fund|
          Reporting::Dashboard::Builders::ExecutiveFundBuilder.call(
            fund: fund
          )
        end
      end

      ####################################################
      # LLM Input Only
      ####################################################

      def build_fund_insights(dashboard_data)
        dashboard_data.funds.map do |fund|

          forecast =
            Reporting::Forecast::ForecastReportService.call(
              fund: fund
            )

          Reporting::Insights::ExecutiveInsightService.call(
            fund: fund,
            forecast_report: forecast
          )
        end
      end
    end
  end
end