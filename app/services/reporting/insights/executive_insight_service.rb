# frozen_string_literal: true

module Reporting
  module Insights
    class ExecutiveInsightService < ApplicationService
      HIGH_CONFIDENCE = 0.85
      MEDIUM_CONFIDENCE = 0.65

      def initialize(
        fund:,
        forecast_report:
      )
        @fund = fund
        @forecast_report = forecast_report
      end

      def call
        return unavailable if forecasts.empty?

        ExecutiveInsight.new(
          executive_summary: executive_summary,
          recommendation: recommendation,
          opportunity_score: opportunity_score,
          market_outlook: market_outlook,
          risk_level: risk_level,
          confidence: confidence_label,
          generated_at: Time.current
        )
      end

      private

      attr_reader :fund,
                  :forecast_report

      def forecasts
        @forecasts ||=
          Array(
            forecast_report[:forecasts]
          )
      end

      def forecast(horizon)
        forecasts.find do |forecast|
          forecast[:horizon] == horizon
        end
      end

      def one_day
        forecast("1d")
      end

      def thirty_day
        forecast("30d")
      end

      def ninety_day
        forecast("90d")
      end

      def executive_summary
        parts = []

        [one_day, thirty_day, ninety_day].compact.each do |forecast|

          next if forecast[:predicted_nav].blank?

          direction =
            forecast[:expected_return_pct].to_f >= 0 ?
            "increase" :
            "decrease"

          parts << "#{forecast[:horizon]}: #{direction} #{forecast[:expected_return_pct].abs.round(2)}%"
        end

        "#{fund.name} outlook — #{parts.join(', ')}."
      end

      def recommendation

        long_term = ninety_day || thirty_day || one_day

        return "Unavailable" unless long_term

        long_term[:recommendation]

      end

      def opportunity_score

        returns =
          forecasts.filter_map do |forecast|
            forecast[:expected_return_pct]
          end

        return nil if returns.empty?

        (
          returns.map(&:abs).sum /
          returns.size *
          10
        ).round.clamp(0, 100)

      end

      def market_outlook

        bullish =
          forecasts.count do |forecast|
            forecast[:trend] == "Bullish"
          end

        bearish =
          forecasts.count do |forecast|
            forecast[:trend] == "Bearish"
          end

        return "Bullish" if bullish > bearish
        return "Bearish" if bearish > bullish

        "Neutral"

      end

      def risk_level

        score =
          average_confidence

        return "Unknown" if score.nil?

        return "Low" if score >= HIGH_CONFIDENCE
        return "Medium" if score >= MEDIUM_CONFIDENCE

        "High"

      end

      def confidence_label

        score =
          average_confidence

        return "Unknown" if score.nil?

        return "High" if score >= HIGH_CONFIDENCE
        return "Medium" if score >= MEDIUM_CONFIDENCE

        "Low"

      end

      def average_confidence

        values =
          forecasts.filter_map do |forecast|
            forecast[:confidence_score]
          end

        return nil if values.empty?

        values.sum / values.size

      end

      def unavailable

        ExecutiveInsight.new(
          executive_summary: "Forecast unavailable.",
          recommendation: "Unavailable",
          opportunity_score: nil,
          market_outlook: "Unavailable",
          risk_level: "Unknown",
          confidence: "Unknown",
          generated_at: Time.current
        )

      end
    end
  end
end