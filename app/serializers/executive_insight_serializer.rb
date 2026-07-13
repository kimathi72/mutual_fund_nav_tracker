class ExecutiveInsightSerializer < ApplicationSerializer
  def initialize(insight)
    @insight = insight
  end

  def as_json(*)
    {
      executive_summary: insight.executive_summary,
      recommendation: insight.recommendation,
      opportunity_score: insight.opportunity_score,
      market_outlook: insight.market_outlook,
      risk_level: insight.risk_level,
      confidence: insight.confidence,
      generated_at: insight.generated_at
    }
  end

  private

  attr_reader :insight
end