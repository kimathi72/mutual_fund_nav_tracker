# frozen_string_literal: true

class FundSerializer
  def initialize(fund)
    @fund = fund
  end

  def as_json(*)
    nav = @fund.latest_daily_nav
    metrics = @fund.latest_metrics

    {
      id: @fund.id,
      isin: @fund.isin,
      name: @fund.name,

      currency: @fund.currency,
      active: @fund.active,

      market_data_symbol: @fund.market_data_symbol,
      exchange_code: @fund.exchange_code,

      latest_nav: nav&.nav,
      nav_date: nav&.nav_date,

      daily_return: metrics&.daily_return,
      weekly_return: metrics&.weekly_return,
      monthly_return: metrics&.monthly_return,
      ytd_return: metrics&.ytd_return,

      moving_average_7: metrics&.moving_average_7,
      moving_average_30: metrics&.moving_average_30,

      volatility_30: metrics&.volatility_30,
      drawdown: metrics&.drawdown
    }
  end
end