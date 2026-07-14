# frozen_string_literal: true

class FundRankingSerializer < ApplicationSerializer
  def initialize(ranking)
    @ranking = ranking
  end

  def as_json(*)
    {
      fund_id: ranking.fund_id,
      fund_name: ranking.fund_name,
      isin: ranking.isin,

      nav_date: ranking.nav_date,
      nav: ranking.nav,
      currency: ranking.currency,

      daily_return: ranking.daily_return,
      weekly_return: ranking.weekly_return,
      monthly_return: ranking.monthly_return,
      ytd_return: ranking.ytd_return,

      moving_average_7: ranking.moving_average_7,
      moving_average_30: ranking.moving_average_30,

      volatility_30: ranking.volatility_30,
      drawdown: ranking.drawdown
    }
  end

  private

  attr_reader :ranking
end