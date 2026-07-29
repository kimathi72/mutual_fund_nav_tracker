# frozen_string_literal: true

module Reporting
  module Risk
    class RiskReportService < ApplicationService
      def initialize(fund:)
        @fund = fund
      end

      def call
        latest_nav = latest_observation

        return empty_report unless latest_nav

        RiskReport.new(
          fund_id: fund.id,
          isin: fund.isin,
          fund_name: fund.name,
          nav_date: latest_nav.nav_date,
          volatility_30: volatility,
          drawdown: drawdown,
          risk_level: risk_level(volatility)
        )
      end

      private

      attr_reader :fund

      def volatility
        @volatility ||= Analytics::VolatilityCalculator
                          .new(nav_records)
                          .calculate
      end

      def drawdown
        @drawdown ||= Analytics::DrawdownCalculator
                        .new(nav_records)
                        .calculate
      end

      def latest_observation
        @latest_observation ||=
          fund.daily_navs
              .order(nav_date: :desc)
              .first
      end

      def nav_records
        @nav_records ||= begin
          fund
            .daily_navs
            .order(nav_date: :asc)
            .pluck(:nav_date, :nav)
            .map do |date, nav|
              {
                date: date,
                nav: nav
              }
            end
        end
      end

      def risk_level(volatility)
        return "Unknown" unless volatility

        volatility_pct = volatility * 100

        case volatility_pct
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

      def empty_report
        RiskReport.new(
          fund_id: fund.id,
          isin: fund.isin,
          fund_name: fund.name,
          nav_date: nil,
          volatility_30: nil,
          drawdown: nil,
          risk_level: "Unknown"
        )
      end
    end
  end
end