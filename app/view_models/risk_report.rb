# frozen_string_literal: true

class RiskReport
  attr_reader \
    :fund_id,
    :isin,
    :fund_name,
    :nav_date,
    :volatility_30,
    :drawdown,
    :risk_level

  def initialize(
    fund_id:,
    isin:,
    fund_name:,
    nav_date:,
    volatility_30:,
    drawdown:,
    risk_level:
  )
    @fund_id = fund_id
    @isin = isin
    @fund_name = fund_name
    @nav_date = nav_date
    @volatility_30 = volatility_30
    @drawdown = drawdown
    @risk_level = risk_level

    freeze
  end
end