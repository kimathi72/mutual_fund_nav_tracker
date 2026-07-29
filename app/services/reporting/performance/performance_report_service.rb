# frozen_string_literal: true

module Reporting
  module Performance
    class PerformanceReportService < ApplicationService
      def initialize(fund:)
        @fund = fund
      end

      def call
        latest_nav = latest_observation

        return empty_report unless latest_nav

        PerformanceReport.new(
          fund_id: fund.id,
          isin: fund.isin,
          fund_name: fund.name,
          nav_date: latest_nav.nav_date,
          latest_nav: latest_nav.nav,
          currency: fund.currency,
          daily_return: returns[:daily],
          weekly_return: returns[:weekly],
          monthly_return: returns[:monthly],
          ytd_return: returns[:ytd],
          moving_average_7: moving_averages[:ma7],
          moving_average_30: moving_averages[:ma30]
        )
      end

      private

      attr_reader :fund

      def returns
        @returns ||= Analytics::ReturnsCalculator
          .new(nav_records)
          .calculate
      end

      def moving_averages
        @moving_averages ||= Analytics::MovingAverageCalculator
          .new(nav_records)
          .calculate
      end

      def latest_observation
        @latest_observation ||= fund
          .daily_navs
          .reorder(nav_date: :desc)
          .first
      end

      def nav_records
        @nav_records ||= fund
          .daily_navs
          .reorder(nav_date: :asc)
          .pluck(:nav_date, :nav)
          .map do |date, nav|
            {
              date: date,
              nav: nav
            }
          end
      end

      def empty_report
        PerformanceReport.new(
          fund_id: fund.id,
          isin: fund.isin,
          fund_name: fund.name,
          nav_date: nil,
          latest_nav: nil,
          currency: fund.currency,
          daily_return: nil,
          weekly_return: nil,
          monthly_return: nil,
          ytd_return: nil,
          moving_average_7: nil,
          moving_average_30: nil
        )
      end
    end
  end
end