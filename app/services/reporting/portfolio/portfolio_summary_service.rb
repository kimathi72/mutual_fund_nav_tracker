# frozen_string_literal: true

module Reporting
  module Portfolio
    class PortfolioSummaryService < ApplicationService
      def initialize(
        report_date:,
        metrics:
      )
        @report_date = report_date
        @metrics = metrics
      end

      def call
        return empty_summary if metrics.empty?

        PortfolioSummary.new(
          report_date: report_date,
          total_funds: metrics.size,
          average_daily_return: average(:daily_return),
          average_weekly_return: average(:weekly_return),
          average_monthly_return: average(:monthly_return),
          average_ytd_return: average(:ytd_return),
          average_volatility: average(:volatility_30),
          best_performer: serialize(metrics.max_by(&:ytd_return)),
          worst_performer: serialize(metrics.min_by(&:ytd_return)),
          highest_risk: serialize(metrics.max_by(&:volatility_30)),
          lowest_risk: serialize(metrics.min_by(&:volatility_30))
        )
      end

      private

      attr_reader :report_date,
                  :metrics

      def average(attribute)
        values =
          metrics
            .map(&attribute)
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

      def empty_summary
        PortfolioSummary.new(
          report_date: report_date,
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
    end
  end
end