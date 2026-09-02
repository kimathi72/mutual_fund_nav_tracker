# frozen_string_literal: true

class PortfolioFundSummary
  attr_reader :fund_id,
              :fund_name,
              :isin,
              :nav,
              :ytd_return,
              :return_since_30_june_2026,
              :volatility,
              :drawdown,
              :portfolio_score

  def initialize(
    fund_id:,
    fund_name:,
    isin:,
    nav:,
    ytd_return:,
    return_since_30_june_2026:,
    volatility:,
    drawdown:,
    portfolio_score:
  )
    @fund_id = fund_id
    @fund_name = fund_name
    @isin = isin
    @nav = nav
    @ytd_return = ytd_return
    @return_since_30_june_2026 = return_since_30_june_2026
    @volatility = volatility
    @drawdown = drawdown
    @portfolio_score = portfolio_score

    freeze
  end
end