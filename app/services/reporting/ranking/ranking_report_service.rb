# frozen_string_literal: true

module Reporting
  module Ranking
    class RankingReportService < ApplicationService
      DEFAULT_LIMIT = 10

      def initialize(
        report_date:,
        metrics:,
        limit: DEFAULT_LIMIT
      )
        @report_date = report_date
        @metrics = metrics.values
        @limit = limit
      end

      def call
        return empty_report if metrics.empty?

        RankingReport.new(
          report_date: report_date,
          top_ytd: serialize(top(:ytd_return)),
          top_monthly: serialize(top(:monthly_return)),
          top_weekly: serialize(top(:weekly_return)),
          top_daily: serialize(top(:daily_return)),
          lowest_risk: serialize(bottom(:volatility_30)),
          highest_risk: serialize(top(:volatility_30)),
          largest_drawdown: serialize(bottom(:drawdown))
        )
      end

      private

      attr_reader :report_date,
                  :metrics,
                  :limit

      def top(attribute)
        metrics
          .select { |m| m.public_send(attribute).present? }
          .sort_by { |m| -m.public_send(attribute).to_f }
          .first(limit)
      end

      def bottom(attribute)
        metrics
          .select { |m| m.public_send(attribute).present? }
          .sort_by { |m| m.public_send(attribute).to_f }
          .first(limit)
      end

      def empty_report
        RankingReport.new(
          report_date: report_date,
          top_ytd: [],
          top_monthly: [],
          top_weekly: [],
          top_daily: [],
          lowest_risk: [],
          highest_risk: [],
          largest_drawdown: []
        )
      end

      def serialize(records)
        records.map do |metric|
          FundRanking.new(
            fund_id: metric.mutual_fund.id,
            fund_name: metric.mutual_fund.name,
            isin: metric.mutual_fund.isin,
            nav_date: metric.daily_nav.nav_date,
            nav: metric.daily_nav.nav,
            currency: metric.daily_nav.currency,
            daily_return: metric.daily_return,
            weekly_return: metric.weekly_return,
            monthly_return: metric.monthly_return,
            ytd_return: metric.ytd_return,
            moving_average_7: metric.moving_average_7,
            moving_average_30: metric.moving_average_30,
            volatility_30: metric.volatility_30,
            drawdown: metric.drawdown
          )
        end
      end
    end
  end
end