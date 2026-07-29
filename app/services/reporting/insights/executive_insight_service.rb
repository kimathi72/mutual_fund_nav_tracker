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
        return unavailable if predictions.empty?

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

      ########################################################
      # Predictions
      ########################################################

      def predictions
        @predictions ||= forecast_report.predictions
      end

      def prediction(horizon)
        predictions.find do |prediction|
          prediction.horizon == horizon
        end
      end

      def one_day
        prediction("1d")
      end

      def thirty_day
        prediction("30d")
      end

      def ninety_day
        prediction("90d")
      end

      ########################################################
      # Executive Summary
      ########################################################

      def executive_summary
        parts = []

        [one_day, thirty_day, ninety_day].compact.each do |prediction|
          next if prediction.predicted_nav.blank?

          direction =
            prediction.expected_return_pct.to_f >= 0 ?
              "increase" :
              "decrease"

          parts << "#{prediction.horizon}: #{direction} #{prediction.expected_return_pct.abs.round(2)}%"
        end

        "#{fund.name} outlook — #{parts.join(', ')}."
      end

      ########################################################
      # Recommendation
      ########################################################

      def recommendation
        long_term =
          ninety_day ||
          thirty_day ||
          one_day

        return "Unavailable" unless long_term

        long_term.recommendation
      end

      ########################################################
      # Opportunity
      ########################################################

      def opportunity_score
        returns =
          predictions.filter_map(&:expected_return_pct)

        return nil if returns.empty?

        (
          returns.map(&:abs).sum /
          returns.size *
          10
        ).round.clamp(0, 100)
      end

      ########################################################
      # Outlook
      ########################################################

      def market_outlook
        bullish =
          predictions.count do |prediction|
            prediction.trend == "Bullish"
          end

        bearish =
          predictions.count do |prediction|
            prediction.trend == "Bearish"
          end

        return "Bullish" if bullish > bearish
        return "Bearish" if bearish > bullish

        "Neutral"
      end

      ########################################################
      # Risk
      ########################################################

      def risk_level
        score = average_confidence

        return "Unknown" if score.nil?
        return "Low" if score >= HIGH_CONFIDENCE
        return "Medium" if score >= MEDIUM_CONFIDENCE

        "High"
      end

      ########################################################
      # Confidence
      ########################################################

      def confidence_label
        score = average_confidence

        return "Unknown" if score.nil?
        return "High" if score >= HIGH_CONFIDENCE
        return "Medium" if score >= MEDIUM_CONFIDENCE

        "Low"
      end

      def average_confidence
        values =
          predictions.filter_map(&:confidence_score)

        return nil if values.empty?

        values.sum.to_f / values.size
      end

      ########################################################
      # Fallback
      ########################################################

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