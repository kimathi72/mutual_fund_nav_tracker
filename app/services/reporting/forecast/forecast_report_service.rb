# frozen_string_literal: true

module Reporting
  module Forecast
    class ForecastReportService < ApplicationService
      HORIZONS = %w[1d 30d 90d].freeze

      def initialize(fund:)
        @fund = fund
      end

      def call
        latest_nav =
          fund.daily_navs.max_by(&:nav_date)

        forecasts =
          fund.forecasts
              .latest
              .index_by(&:horizon)

        {
          fund: {
            id: fund.id,
            isin: fund.isin,
            name: fund.name
          },

          latest_nav: {
            value: latest_nav&.nav,
            date: latest_nav&.nav_date
          },

          forecasts:
            HORIZONS.map do |horizon|

              build_forecast(
                latest_nav,
                forecasts[horizon],
                horizon
              )

            end
        }
      end

      private

      attr_reader :fund

      def build_forecast(
        latest_nav,
        forecast,
        horizon
      )

        return empty_forecast(horizon) unless forecast

        {
          horizon: horizon,

          predicted_at:
            forecast.predicted_at,

          target_date:
            forecast.target_date,

          predicted_nav:
            forecast.predicted_nav,

          lower_bound:
            forecast.lower_bound,

          upper_bound:
            forecast.upper_bound,

          confidence_score:
            forecast.confidence_score,

          expected_return_pct:
            forecast.expected_return_pct,

          model_version:
            forecast.model_version,

          trend:
            trend(
              latest_nav&.nav,
              forecast.predicted_nav
            ),

          recommendation:
            recommendation(
              forecast.expected_return_pct,
              forecast.confidence_score
            )
        }
      end

      def empty_forecast(horizon)
        {
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
        }
      end

      def trend(current, predicted)
        return "Unavailable" if current.blank?
        return "Bullish" if predicted > current
        return "Bearish" if predicted < current

        "Neutral"
      end

      def recommendation(return_pct, confidence)

        return "Unavailable" if return_pct.blank?

        return "Strong Buy" if return_pct >= 5 && confidence >= 0.90
        return "Buy" if return_pct >= 2
        return "Hold" if return_pct > -2
        return "Sell" if return_pct > -5

        "Strong Sell"

      end
    end
  end
end