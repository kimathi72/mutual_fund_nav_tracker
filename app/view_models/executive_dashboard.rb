# frozen_string_literal: true

class ExecutiveDashboard
  attr_reader :generated_at,
              :summary,
              :rankings,
              :portfolio_insight,
              :funds,
              :briefing

  def initialize(
    generated_at:,
    summary:,
    rankings:,
    portfolio_insight:,
    funds:,
    briefing: nil
  )
    @generated_at = generated_at
    @summary = summary
    @rankings = rankings
    @portfolio_insight = portfolio_insight
    @funds = funds
    @briefing = briefing

    freeze
  end
end