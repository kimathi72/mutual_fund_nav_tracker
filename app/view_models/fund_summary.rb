# frozen_string_literal: true

class FundSummary
  attr_reader :fund_id,
              :fund_name,
              :isin,
              :nav,
              :ytd_return,
              :volatility,
              :drawdown

  def initialize(
    fund_id:,
    fund_name:,
    isin:,
    nav:,
    ytd_return:,
    volatility:,
    drawdown:
  )
    @fund_id = fund_id
    @fund_name = fund_name
    @isin = isin
    @nav = nav
    @ytd_return = ytd_return
    @volatility = volatility
    @drawdown = drawdown

    freeze
  end
end