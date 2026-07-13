# frozen_string_literal: true

class FundSummarySerializer < ApplicationSerializer
  def initialize(summary)
    @summary = summary
  end

  def as_json(*)
    {
      fund_id: summary.fund_id,
      fund_name: summary.fund_name,
      isin: summary.isin,
      nav: summary.nav,
      ytd_return: summary.ytd_return,
      volatility: summary.volatility,
      drawdown: summary.drawdown
    }
  end

  private

  attr_reader :summary
end