# frozen_string_literal: true

module Reporting
  module Insights
    class PortfolioExecutiveInsightService < ApplicationService
      def initialize(summary:)
        @summary = summary
      end

      def call
        return unavailable unless summary.report_date.present?

        PortfolioExecutiveInsight.new(
          portfolio_health: portfolio_health,
          market_sentiment: market_sentiment,
          portfolio_risk: portfolio_risk,
          executive_recommendation: executive_recommendation,
          generated_at: Time.current
        )
      end

      private

      attr_reader :summary

      def portfolio_health
        ytd = summary.average_ytd_return.to_f

        return "Excellent" if ytd >= 15
        return "Strong" if ytd >= 8
        return "Stable" if ytd >= 3
        return "Weak" if ytd >= 0

        "Declining"
      end

      def market_sentiment
        weekly = summary.average_weekly_return.to_f

        return "Bullish" if weekly > 0.5
        return "Bearish" if weekly < -0.5

        "Neutral"
      end

      def portfolio_risk
        volatility = summary.average_volatility.to_f

        return "Low" if volatility < 0.02
        return "Medium" if volatility < 0.05

        "High"
      end

      def executive_recommendation
        ytd = summary.average_ytd_return.to_f

        if ytd > 8 && portfolio_risk == "Low"
          "Increase exposure to outperforming funds."
        elsif ytd > 0
          "Maintain current allocation while monitoring volatility."
        else
          "Review portfolio allocation and reduce exposure to underperforming funds."
        end
      end

      def unavailable
        PortfolioExecutiveInsight.new(
          portfolio_health: "Unknown",
          market_sentiment: "Unknown",
          portfolio_risk: "Unknown",
          executive_recommendation: "No portfolio data available.",
          generated_at: Time.current
        )
      end
    end
  end
end