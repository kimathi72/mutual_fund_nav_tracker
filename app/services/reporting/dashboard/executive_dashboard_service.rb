# frozen_string_literal: true

module Reporting
  module Dashboard
    class ExecutiveDashboardService < ApplicationService
      def call
        dashboard_data =
          DashboardDataLoaderService.call
        metrics =
          metrics(dashboard_data)
        summary =
          Reporting::Portfolio::PortfolioSummaryService.call(
            report_date: dashboard_data.report_date,
            metrics: metrics
          )

        rankings =
          Reporting::Ranking::RankingReportService.call(
            report_date: dashboard_data.report_date,
            metrics: metrics
          )

        portfolio_insight =
          Reporting::Insights::PortfolioExecutiveInsightService.call(
            summary: summary
          )

        funds =
          build_funds(dashboard_data)

        briefing =
          Llm::ExecutiveBriefingService.call(
            summary: summary,
            portfolio_insights: portfolio_insight,
            fund_insights: funds.map(&:executive_insight)
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

      def latest_nav_for(fund, report_date)
        fund.daily_navs.find do |nav|
          nav.nav_date == report_date
        end
      end

      def latest_forecast_for(fund)
        fund.forecasts.max_by(&:forecast_date)
      end

      def build_funds(dashboard_data)
        dashboard_data.funds.map do |fund|

          metric =
            metric_for(
              fund,
              dashboard_data.report_date
            )

          latest_nav =
            latest_nav_for(
              fund,
              dashboard_data.report_date
            )

          forecast =
            latest_forecast_for(fund)

          performance =
            Reporting::Performance::PerformanceReportService.call(
              fund: fund,
              metric: metric
            )

          risk =
            Reporting::Risk::RiskReportService.call(
              fund: fund,
              metric: metric
            )

          forecast_report =
            Reporting::Forecast::ForecastReportService.call(
              fund: fund,
              forecast: forecast,
              latest_nav: latest_nav
            )
          
          executive_insight =
            Reporting::Insights::ExecutiveInsightService.call(
              fund: fund,
              forecast_report: forecast_report
            )

          ExecutiveFund.new(
            performance: performance,
            risk: risk,
            forecast: forecast_report,
            executive_insight: executive_insight,
            nav_history: fund.nav_history,
            volatility_history: fund.volatility_history,
            forecast_series: fund.forecast_series
          )
        end
      end
    end
  end
end