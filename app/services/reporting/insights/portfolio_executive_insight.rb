# frozen_string_literal: true

module Reporting
  module Insights
    class PortfolioExecutiveInsight
      attr_reader :portfolio_health,
                  :market_sentiment,
                  :portfolio_risk,
                  :executive_recommendation,
                  :generated_at

      def initialize(
        portfolio_health:,
        market_sentiment:,
        portfolio_risk:,
        executive_recommendation:,
        generated_at:
      )
        @portfolio_health = portfolio_health
        @market_sentiment = market_sentiment
        @portfolio_risk = portfolio_risk
        @executive_recommendation = executive_recommendation
        @generated_at = generated_at
      end
    end
  end
end