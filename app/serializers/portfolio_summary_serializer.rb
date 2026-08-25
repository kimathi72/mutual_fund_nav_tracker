# frozen_string_literal: true

class PortfolioSummarySerializer < ApplicationSerializer
  def initialize(summary)
    @summary = summary
  end

  def as_json(*)
    {
      report_date: summary.report_date,
      total_funds: summary.total_funds,

      average_daily_return: summary.average_daily_return,
      average_weekly_return: summary.average_weekly_return,
      average_monthly_return: summary.average_monthly_return,
      average_ytd_return: summary.average_ytd_return,
      average_volatility: summary.average_volatility,

      buy_count: summary.buy_count,
      hold_count: summary.hold_count,
      sell_count: summary.sell_count,

      bullish_count: summary.bullish_count,
      bearish_count: summary.bearish_count,

      average_opportunity_score: summary.average_opportunity_score,

      best_performer: fund(summary.best_performer),
      worst_performer: fund(summary.worst_performer),
      highest_risk: fund(summary.highest_risk),
      lowest_risk: fund(summary.lowest_risk)
    }
  end

  private

  attr_reader :summary

  def fund(value)
    return nil unless value

    PortfolioFundSummarySerializer.new(value).as_json
  end
end