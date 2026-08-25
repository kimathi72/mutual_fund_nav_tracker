# frozen_string_literal: true

class PortfolioInsightSerializer
  def initialize(insight)
    @insight = insight
  end

  def as_json
    {
      portfolio_health: insight.portfolio_health,
      market_sentiment: insight.market_sentiment,
      portfolio_risk: insight.portfolio_risk,
      executive_recommendation: insight.executive_recommendation,
      generated_at: insight.generated_at
    }
  end

  private

  attr_reader :insight
end