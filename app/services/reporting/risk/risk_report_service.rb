# frozen_string_literal: true

module Reporting
  module Risk
    class RiskReportService < ApplicationService
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

          volatility_30: metric.volatility_30,
          drawdown: metric.drawdown,

          risk_level: risk_level(metric.volatility_30)
        }
      end

      private

      attr_reader :fund

      def risk_level(volatility)
        return "Unknown" if volatility.nil?

        value = volatility.to_f.abs * 100

        case value
        when 0...5
          "Low"
        when 5...10
          "Moderate"
        when 10...20
          "Medium"
        else
          "High"
        end
      end
    end
  end
end