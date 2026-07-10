# frozen_string_literal: true

module Reporting
  module Forecast
    class ForecastReportService < ApplicationService
      def initialize(fund:)
        @fund = fund
      end

      def call
        forecast = fund.forecasts.first

        return no_forecast unless forecast

        latest_nav = fund.daily_navs.latest_first.first

        {
          fund_id: fund.id,
          isin: fund.isin,
          fund_name: fund.name,

          latest_nav: latest_nav&.nav,
          latest_nav_date: latest_nav&.nav_date,

          forecast_date: forecast.forecast_date,
          target_date: forecast.target_date,

          model_version: forecast.model_version,

          predicted_nav: forecast.predicted_nav,

          expected_change_pct:
            percentage_change(
              latest_nav&.nav,
              forecast.predicted_nav
            ),

          confidence: confidence(forecast),

          trend:
            calculate_trend(
              latest_nav&.nav,
              forecast.predicted_nav
            )
        }
      end

      private

      attr_reader :fund

      def confidence(forecast)
        forecast.confidence_score || forecast.confidence
      end

      def percentage_change(current, predicted)
        return nil if current.blank?
        return nil if predicted.blank?
        return nil if current.zero?

        (((predicted - current) / current) * 100).round(2)
      end

      def calculate_trend(current, predicted)
        return "Unavailable" if current.blank?
        return "Unavailable" if predicted.blank?

        change =
          percentage_change(current, predicted)

        return "Bullish" if change >= 1
        return "Bearish" if change <= -1

        "Neutral"
      end

      def no_forecast
        {
          fund_id: fund.id,
          isin: fund.isin,
          fund_name: fund.name,

          latest_nav: nil,
          latest_nav_date: nil,

          forecast_date: nil,
          target_date: nil,

          model_version: nil,

          predicted_nav: nil,

          expected_change_pct: nil,

          confidence: nil,

          trend: "Unavailable"
        }
      end
    end
  end
end