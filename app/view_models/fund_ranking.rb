# frozen_string_literal: true

class FundRanking
  attr_reader \
    :fund_id,
    :fund_name,
    :isin,
    :nav_date,
    :nav,
    :currency,
    :daily_return,
    :weekly_return,
    :monthly_return,
    :ytd_return,
    :moving_average_7,
    :moving_average_30,
    :volatility_30,
    :drawdown

  def initialize(
    fund_id:,
    fund_name:,
    isin:,
    nav_date:,
    nav:,
    currency:,
    daily_return:,
    weekly_return:,
    monthly_return:,
    ytd_return:,
    moving_average_7:,
    moving_average_30:,
    volatility_30:,
    drawdown:
  )
    @fund_id = fund_id
    @fund_name = fund_name
    @isin = isin
    @nav_date = nav_date
    @nav = nav
    @currency = currency
    @daily_return = daily_return
    @weekly_return = weekly_return
    @monthly_return = monthly_return
    @ytd_return = ytd_return
    @moving_average_7 = moving_average_7
    @moving_average_30 = moving_average_30
    @volatility_30 = volatility_30
    @drawdown = drawdown

    freeze
  end
end