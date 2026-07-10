# frozen_string_literal: true

module Reporting
  module Insights
    class PortfolioExecutiveInsightService < ApplicationService
      def call
        summary =
          Reporting::Portfolio::PortfolioSummaryService
            .new
            .call

        return unavailable if summary.blank?

        {
          portfolio_health: portfolio_health(summary),
          market_sentiment: market_sentiment(summary),
          portfolio_risk: portfolio_risk(summary),
          executive_recommendation: executive_recommendation(summary),
          generated_at: Time.current
        }
      end

      private

      def portfolio_health(summary)
        ytd =
          summary[:average_ytd_return].to_f

        return "Excellent" if ytd >= 15
        return "Strong" if ytd >= 8
        return "Stable" if ytd >= 3
        return "Weak" if ytd >= 0

        "Declining"
      end

      def market_sentiment(summary)
        weekly =
          summary[:average_weekly_return].to_f

        return "Bullish" if weekly > 0.5
        return "Bearish" if weekly < -0.5

        "Neutral"
      end

      def portfolio_risk(summary)
        volatility =
          summary[:average_volatility].to_f

        return "Low" if volatility < 0.02
        return "Medium" if volatility < 0.05

        "High"
      end

      def executive_recommendation(summary)
        ytd =
          summary[:average_ytd_return].to_f

        risk =
          portfolio_risk(summary)

        if ytd > 8 && risk == "Low"
          "Increase exposure to outperforming funds."
        elsif ytd > 0
          "Maintain current allocation while monitoring volatility."
        else
          "Review portfolio allocation and reduce exposure to underperforming funds."
        end
      end

      def unavailable
        {
          portfolio_health: "Unknown",
          market_sentiment: "Unknown",
          portfolio_risk: "Unknown",
          executive_recommendation: "Portfolio data unavailable.",
          generated_at: Time.current
        }
      end
    end
  end
end