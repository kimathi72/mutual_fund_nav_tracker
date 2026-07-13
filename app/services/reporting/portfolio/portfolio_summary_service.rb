# frozen_string_literal: true

module Reporting
  module Portfolio
    class PortfolioSummaryService < ApplicationService
      def call
        latest_date = DailyNav.maximum(:nav_date)

        return empty_summary unless latest_date

        metrics =
          DailyNavMetric
            .includes(:mutual_fund, :daily_nav)
            .joins(:daily_nav)
            .where(daily_navs: { nav_date: latest_date })

        return empty_summary if metrics.empty?

        PortfolioSummary.new(
          report_date: latest_date,
          total_funds: metrics.count,
          average_daily_return: average(metrics, :daily_return),
          average_weekly_return: average(metrics, :weekly_return),
          average_monthly_return: average(metrics, :monthly_return),
          average_ytd_return: average(metrics, :ytd_return),
          average_volatility: average(metrics, :volatility_30),
          best_performer: serialize(metrics.max_by(&:ytd_return)),
          worst_performer: serialize(metrics.min_by(&:ytd_return)),
          highest_risk: serialize(metrics.max_by(&:volatility_30)),
          lowest_risk: serialize(metrics.min_by(&:volatility_30))
        )
      end

      private

      def empty_summary
        PortfolioSummary.new(
          report_date: nil,
          total_funds: 0,
          average_daily_return: nil,
          average_weekly_return: nil,
          average_monthly_return: nil,
          average_ytd_return: nil,
          average_volatility: nil,
          best_performer: nil,
          worst_performer: nil,
          highest_risk: nil,
          lowest_risk: nil
        )
      end

      def average(metrics, column)
        values =
          metrics
            .map(&column)
            .compact

        return nil if values.empty?

        values.sum.to_d / values.size
      end

      def serialize(metric)
        return nil unless metric

        FundSummary.new(
          fund_id: metric.mutual_fund.id,
          fund_name: metric.mutual_fund.name,
          isin: metric.mutual_fund.isin,
          nav: metric.daily_nav.nav,
          ytd_return: metric.ytd_return,
          volatility: metric.volatility_30,
          drawdown: metric.drawdown
        )
      end
    end
  end
end