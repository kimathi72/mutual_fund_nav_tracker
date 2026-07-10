# frozen_string_literal: true

module Reporting
  module Insights
    class ExecutiveInsightService < ApplicationService
      BULLISH_THRESHOLD = 1.0
      BEARISH_THRESHOLD = -1.0

      def initialize(fund:)
        @fund = fund
      end

      def call
        report =
          Reporting::Forecast::ForecastReportService
            .new(fund: fund)
            .call

        return unavailable unless forecast_available?(report)

        {
          executive_summary: executive_summary(report),
          recommendation: recommendation(report),
          opportunity_score: opportunity_score(report),
          market_outlook: market_outlook(report),
          risk_level: risk_level(report),
          confidence: confidence_label(report[:confidence]),
          generated_at: Time.current
        }
      end

      private

      attr_reader :fund

      def forecast_available?(report)
        report[:predicted_nav].present?
      end

      def executive_summary(report)
        change = report[:expected_change_pct].to_f.round(2)

        direction =
          change.positive? ? "increase" : "decrease"

        <<~TEXT.squish
          #{fund.name} is forecast to #{direction}
          by #{change.abs}% on #{report[:target_date]}.
          Overall outlook is #{report[:trend].downcase}.
        TEXT
      end

      def recommendation(report)
        case report[:trend]
        when "Bullish"
          "Increase exposure"

        when "Bearish"
          "Reduce exposure"

        else
          "Hold position"
        end
      end

      def opportunity_score(report)
        change =
          report[:expected_change_pct].to_f.abs

        score =
          (change * 10).round

        score.clamp(0, 100)
      end

      def market_outlook(report)
        report[:trend]
      end

      def risk_level(report)
        confidence =
          report[:confidence]

        return "Unknown" if confidence.blank?

        return "Low" if confidence >= 0.85
        return "Medium" if confidence >= 0.65

        "High"
      end

      def confidence_label(confidence)
        return "Unknown" if confidence.blank?

        return "High" if confidence >= 0.85
        return "Medium" if confidence >= 0.65

        "Low"
      end

      def unavailable
        {
          executive_summary: "Forecast unavailable.",
          recommendation: nil,
          opportunity_score: nil,
          market_outlook: "Unavailable",
          risk_level: "Unknown",
          confidence: "Unknown",
          generated_at: Time.current
        }
      end
    end
  end
end