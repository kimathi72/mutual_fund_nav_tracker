# frozen_string_literal: true

class FundSummary
  attr_reader \
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
    :drawdown,
    :recommendation,
    :market_outlook,
    :opportunity_score,
    :portfolio_score

  def initialize(
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
    drawdown:,
    recommendation:,
    market_outlook:,
    opportunity_score:,
    portfolio_score:
  )
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

    @recommendation = recommendation
    @market_outlook = market_outlook
    @opportunity_score = opportunity_score

    @portfolio_score = portfolio_score

    freeze
  end
end