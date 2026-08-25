# frozen_string_literal: true

module Reporting
  module Forecast
    class ForecastReportService < ApplicationService
      HORIZONS = %w[1d 30d 90d].freeze

      def initialize(fund:)
        @fund = fund
      end

      def call
        ForecastReport.new(
          predictions: prediction_reports
        )
      end

      private

      attr_reader :fund

      def latest_nav
        @latest_nav ||= fund.latest_daily_nav
      end

      def latest_forecasts
        @latest_forecasts ||=
          fund
            .forecasts
            .latest_run
            .index_by(&:horizon)
      end

      def prediction_reports
        HORIZONS.map do |horizon|
          build_prediction(
            latest_forecasts[horizon],
            horizon
          )
        end
      end

      def build_prediction(forecast, horizon)
        return empty_prediction(horizon) unless forecast


        ForecastReport::Prediction.new(
          horizon: horizon,

          predicted_at: forecast.predicted_at,
          target_date: forecast.target_date,

          predicted_nav: forecast.predicted_nav,

          lower_bound: forecast.lower_bound,
          upper_bound: forecast.upper_bound,

          confidence_score: forecast.confidence_score,

          expected_return_pct: forecast.expected_return_pct,

          model_version: forecast.model_version,

          trend: trend(
            latest_nav&.nav,
            forecast.predicted_nav
          ),

          recommendation: recommendation(
            forecast.expected_return_pct,
            forecast.confidence_score
          )
        )
      end

      def empty_prediction(horizon)
        ForecastReport::Prediction.new(
          horizon: horizon,

          predicted_at: nil,
          target_date: nil,

          predicted_nav: nil,

          lower_bound: nil,
          upper_bound: nil,

          confidence_score: nil,

          expected_return_pct: nil,

          model_version: nil,

          trend: "Unavailable",

          recommendation: "Unavailable"
        )
      end

      ######################################################
      ## Forecast interpretation
      ######################################################

      def trend(current_nav, predicted_nav)
        return "Unavailable" if current_nav.blank?
        return "Unavailable" if predicted_nav.blank?

        if predicted_nav > current_nav
          "Bullish"
        elsif predicted_nav < current_nav
          "Bearish"
        else
          "Neutral"
        end
      end

      def recommendation(expected_return, confidence)
        return "Unavailable" if expected_return.nil?
        return "Unavailable" if confidence.nil?

        case expected_return
        when 0.10..Float::INFINITY
          confidence >= 0.90 ? "Strong Buy" : "Buy"

        when 0.03...0.10
          "Buy"

        when -0.03...0.03
          "Hold"

        when -0.10...-0.03
          "Sell"

        else
          "Strong Sell"
        end
      end
    end
  end
end