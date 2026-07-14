# frozen_string_literal: true

module Reporting
  module Performance
    class PerformanceReportService < ApplicationService
      def initialize(
        fund:,
        metric:
      )
        @fund = fund
        @metric = metric
      end

      def call
        
        return empty_report unless metric

        PerformanceReport.new(
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
        )
      end

      private

      attr_reader :fund,
                  :metric
      
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