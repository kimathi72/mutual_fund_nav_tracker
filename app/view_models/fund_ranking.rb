
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
    :return_since_30_june_2026,
    :volatility,
    :drawdown,
    :portfolio_score

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
    return_since_30_june_2026:,
    volatility:,
    drawdown:,
    portfolio_score:
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
    @return_since_30_june_2026 = return_since_30_june_2026

    @volatility = volatility
    @drawdown = drawdown
    @portfolio_score = portfolio_score

    freeze
  end
end
