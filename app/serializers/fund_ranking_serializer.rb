# frozen_string_literal: true

class FundRankingSerializer < ApplicationSerializer
  def initialize(ranking)
    @ranking = ranking
  end

  def as_json(*)
    {
      rank: ranking.rank,

      id: ranking.fund_id,
      name: ranking.fund_name,
      isin: ranking.isin,

      nav: ranking.nav,
      currency: ranking.currency,

      daily_return: ranking.daily_return,
      weekly_return: ranking.weekly_return,
      monthly_return: ranking.monthly_return,
      ytd_return: ranking.ytd_return,
      return_since_30_june_2026:
        ranking.return_since_30_june_2026,

      volatility: ranking.volatility,
      drawdown: ranking.drawdown,

      portfolio_score: ranking.portfolio_score
    }
  end

  private

  attr_reader :ranking
end