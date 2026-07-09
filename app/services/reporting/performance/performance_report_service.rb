# frozen_string_literal: true

module Reporting
  module Performance
    class PerformanceReportService < ApplicationService
      def initialize(fund:)
        @fund = fund
      end

      def call
        metric =
          DailyNavMetric
            .includes(:daily_nav)
            .where(mutual_fund: fund)
            .order("daily_navs.nav_date DESC")
            .references(:daily_nav)
            .first

        return {} unless metric

        {
          fund_id: fund.id,
          isin: fund.isin,
          fund_name: fund.name,

          nav_date: metric.daily_nav.nav_date,
          latest_nav: metric.daily_nav.nav,

          currency: fund.currency,

          daily_return: metric.daily_return,
          weekly_return: metric.weekly_return,
          monthly_return: metric.monthly_return,
          ytd_return: metric.ytd_return,

          moving_average_7: metric.moving_average_7,
          moving_average_30: metric.moving_average_30
        }
      end

      private

      attr_reader :fund
    end
  end
end