# frozen_string_literal: true

class ExecutiveInsight
  attr_reader :executive_summary,
              :recommendation,
              :opportunity_score,
              :market_outlook,
              :risk_level,
              :confidence,
              :generated_at

  def initialize(
    executive_summary:,
    recommendation:,
    opportunity_score:,
    market_outlook:,
    risk_level:,
    confidence:,
    generated_at:
  )
    @executive_summary = executive_summary
    @recommendation = recommendation
    @opportunity_score = opportunity_score
    @market_outlook = market_outlook
    @risk_level = risk_level
    @confidence = confidence
    @generated_at = generated_at

    freeze
  end
end