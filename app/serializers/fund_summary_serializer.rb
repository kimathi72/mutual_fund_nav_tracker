# frozen_string_literal: true

class FundSummarySerializer < ApplicationSerializer
  def initialize(summary)
    @summary = summary
  end

  def as_json(*)
    {
      id: summary.fund_id,
      name: summary.fund_name,
      isin: summary.isin,

      nav: summary.nav,

      ytd_return: summary.ytd_return,

      volatility: summary.volatility,

      drawdown: summary.drawdown,

      recommendation: summary.recommendation,

      market_outlook: summary.market_outlook,

      opportunity_score: summary.opportunity_score
    }
  end

  private

  attr_reader :summary
end