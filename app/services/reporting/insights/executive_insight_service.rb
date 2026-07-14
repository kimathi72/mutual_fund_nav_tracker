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
        return unavailable unless forecast_available?(forecast_report)

        ExecutiveInsight.new(
          executive_summary: executive_summary(forecast_report),
          recommendation: recommendation(forecast_report),
          opportunity_score: opportunity_score(forecast_report),
          market_outlook: market_outlook(forecast_report),
          risk_level: risk_level(forecast_report.confidence),
          confidence: confidence_label(forecast_report.confidence),
          generated_at: Time.current
        )
      end

      private

      attr_reader :fund,
                  :forecast_report

      def forecast_available?(report)
        report.predicted_nav.present?
      end

      def executive_summary(report)
        change = report.expected_change_pct.to_f.round(2)

        direction =
          change.positive? ? "increase" : "decrease"

        <<~TEXT.squish
          #{fund.name} is forecast to #{direction}
          by #{change.abs}% on #{report.target_date}.
          Overall outlook is #{report.trend.downcase}.
        TEXT
      end

      def recommendation(report)
        case report.trend
        when "Bullish"
          "Increase exposure"
        when "Bearish"
          "Reduce exposure"
        else
          "Hold position"
        end
      end

      def opportunity_score(report)
        score =
          (report.expected_change_pct.to_f.abs * 10).round

        score.clamp(0, 100)
      end

      def market_outlook(report)
        report.trend
      end

      def risk_level(confidence)
        return "Unknown" if confidence.blank?

        return "Low" if confidence >= HIGH_CONFIDENCE
        return "Medium" if confidence >= MEDIUM_CONFIDENCE

        "High"
      end

      def confidence_label(confidence)
        return "Unknown" if confidence.blank?

        return "High" if confidence >= HIGH_CONFIDENCE
        return "Medium" if confidence >= MEDIUM_CONFIDENCE

        "Low"
      end

      def unavailable
        ExecutiveInsight.new(
          executive_summary: "Forecast unavailable.",
          recommendation: nil,
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