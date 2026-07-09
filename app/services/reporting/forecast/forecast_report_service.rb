# frozen_string_literal: true

module Reporting
  module Forecast
    class ForecastReportService < ApplicationService
      def initialize(fund:)
        @fund = fund
      end

      def call
        forecast =
          ::Forecast
            .where(mutual_fund: fund)
            .latest_first
            .first

        return no_forecast unless forecast

        latest_nav =
          fund
            .daily_navs
            .latest_first
            .first

        trend =
          calculate_trend(
            latest_nav&.nav,
            forecast.predicted_nav
          )

        {
          fund_id: fund.id,

          isin: fund.isin,

          fund_name: fund.name,

          latest_nav: latest_nav&.nav,

          latest_nav_date: latest_nav&.nav_date,

          target_date: forecast.target_date,

          model: forecast.model_name,

          predicted_nav: forecast.predicted_nav,

          expected_change_pct:
            percentage_change(
              latest_nav&.nav,
              forecast.predicted_nav
            ),

          confidence: forecast.confidence_score,

          trend: trend
        }
      end

      private

      attr_reader :fund

      def percentage_change(current, predicted)
        return nil if current.blank?
        return nil if predicted.blank?
        return nil if current.zero?

        ((predicted - current) / current) * 100.0
      end

      def calculate_trend(current, predicted)
        return "Unknown" if current.blank?
        return "Unknown" if predicted.blank?

        diff =
          ((predicted - current) / current) * 100.0

        return "Bullish" if diff >= 1.0
        return "Bearish" if diff <= -1.0

        "Neutral"
      end

      def no_forecast
        {
          fund_id: fund.id,

          isin: fund.isin,

          fund_name: fund.name,

          latest_nav: nil,

          latest_nav_date: nil,

          target_date: nil,

          model: nil,

          predicted_nav: nil,

          expected_change_pct: nil,

          confidence: nil,

          trend: "Unavailable"
        }
      end
    end
  end
end