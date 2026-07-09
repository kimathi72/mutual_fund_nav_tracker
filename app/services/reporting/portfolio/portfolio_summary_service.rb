# frozen_string_literal: true

module Reporting
  module Portfolio
    class PortfolioSummaryService < ApplicationService
      def call
        latest_date = DailyNav.maximum(:nav_date)

        return {} unless latest_date

        metrics =
          DailyNavMetric
            .includes(:mutual_fund, :daily_nav)
            .joins(:daily_nav)
            .where(daily_navs: { nav_date: latest_date })

        return {} if metrics.empty?

        {
          report_date: latest_date,

          total_funds: metrics.count,

          average_daily_return:
            average(metrics, :daily_return),

          average_weekly_return:
            average(metrics, :weekly_return),

          average_monthly_return:
            average(metrics, :monthly_return),

          average_ytd_return:
            average(metrics, :ytd_return),

          average_volatility:
            average(metrics, :volatility_30),

          best_performer:
            best_performer(metrics),

          worst_performer:
            worst_performer(metrics),

          highest_risk:
            highest_risk(metrics),

          lowest_risk:
            lowest_risk(metrics)
        }
      end

      private

      def average(metrics, column)
        values =
          metrics
            .map(&column)
            .compact

        return nil if values.empty?

        values.sum.to_d / values.size
      end

      def best_performer(metrics)
        metric = metrics.max_by(&:ytd_return)

        serialize(metric)
      end

      def worst_performer(metrics)
        metric = metrics.min_by(&:ytd_return)

        serialize(metric)
      end

      def highest_risk(metrics)
        metric = metrics.max_by(&:volatility_30)

        serialize(metric)
      end

      def lowest_risk(metrics)
        metric = metrics.min_by(&:volatility_30)

        serialize(metric)
      end

      def serialize(metric)
        return nil unless metric

        {
          fund_id: metric.mutual_fund.id,
          fund_name: metric.mutual_fund.name,
          isin: metric.mutual_fund.isin,

          nav: metric.daily_nav.nav,

          ytd_return: metric.ytd_return,

          volatility: metric.volatility_30,

          drawdown: metric.drawdown
        }
      end
    end
  end
end