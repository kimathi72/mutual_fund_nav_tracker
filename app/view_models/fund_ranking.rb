# frozen_string_literal: true

class FundRanking
  attr_reader \
    :rank,
    :fund_id,
    :fund_name,
    :isin,
    :nav,
    :currency,
    :daily_return,
    :weekly_return,
    :monthly_return,
    :ytd_return,
    :volatility,
    :drawdown

  def initialize(
    rank:,
    fund_id:,
    fund_name:,
    isin:,
    nav:,
    currency:,
    daily_return:,
    weekly_return:,
    monthly_return:,
    ytd_return:,
    volatility:,
    drawdown:
  )
    @rank = rank
    @fund_id = fund_id
    @fund_name = fund_name
    @isin = isin
    @nav = nav
    @currency = currency
    @daily_return = daily_return
    @weekly_return = weekly_return
    @monthly_return = monthly_return
    @ytd_return = ytd_return
    @volatility = volatility
    @drawdown = drawdown

    freeze
  end
end