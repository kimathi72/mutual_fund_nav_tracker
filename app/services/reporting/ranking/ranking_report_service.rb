# frozen_string_literal: true

module Reporting
  module Ranking
    class RankingReportService < ApplicationService
      DEFAULT_LIMIT = 10

      def initialize(limit: DEFAULT_LIMIT)
        @limit = limit
      end

      def call
        return {} if latest_metrics.none?

        {
          report_date: report_date,

          top_ytd:
            serialize(
              latest_metrics
                .order(ytd_return: :desc)
                .limit(limit)
            ),

          top_monthly:
            serialize(
              latest_metrics
                .order(monthly_return: :desc)
                .limit(limit)
            ),

          top_weekly:
            serialize(
              latest_metrics
                .order(weekly_return: :desc)
                .limit(limit)
            ),

          top_daily:
            serialize(
              latest_metrics
                .order(daily_return: :desc)
                .limit(limit)
            ),

          lowest_risk:
            serialize(
              latest_metrics
                .order(volatility_30: :asc)
                .limit(limit)
            ),

          highest_risk:
            serialize(
              latest_metrics
                .order(volatility_30: :desc)
                .limit(limit)
            ),

          largest_drawdown:
            serialize(
              latest_metrics
                .order(drawdown: :asc)
                .limit(limit)
            )
        }
      end

      private

      attr_reader :limit

      def latest_metrics
        @latest_metrics ||= begin
          latest_date = DailyNav.maximum(:nav_date)

          return DailyNavMetric.none unless latest_date

          DailyNavMetric
            .includes(:mutual_fund, :daily_nav)
            .joins(:daily_nav)
            .where(daily_navs: { nav_date: latest_date })
        end
      end

      def report_date
        @report_date ||= latest_metrics.first&.daily_nav&.nav_date
      end

      def serialize(records)
        records.map do |metric|
          {
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
          }
        end
      end
    end
  end
end