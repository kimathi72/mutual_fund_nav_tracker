# frozen_string_literal: true

class PortfolioSummary
  attr_reader \
    :report_date,
    :total_funds,

    :average_daily_return,
    :average_weekly_return,
    :average_monthly_return,
    :average_ytd_return,
    :average_volatility,

    :best_performer,
    :worst_performer,
    :highest_risk,
    :lowest_risk,

    :buy_count,
    :hold_count,
    :sell_count,

    :bullish_count,
    :bearish_count,

    :average_opportunity_score

  def initialize(
    report_date:,
    total_funds:,

    average_daily_return:,
    average_weekly_return:,
    average_monthly_return:,
    average_ytd_return:,
    average_volatility:,

    best_performer:,
    worst_performer:,
    highest_risk:,
    lowest_risk:,

    buy_count:,
    hold_count:,
    sell_count:,

    bullish_count:,
    bearish_count:,

    average_opportunity_score:
  )
    @report_date = report_date
    @total_funds = total_funds

    @average_daily_return = average_daily_return
    @average_weekly_return = average_weekly_return
    @average_monthly_return = average_monthly_return
    @average_ytd_return = average_ytd_return
    @average_volatility = average_volatility

    @best_performer = best_performer
    @worst_performer = worst_performer
    @highest_risk = highest_risk
    @lowest_risk = lowest_risk

    @buy_count = buy_count
    @hold_count = hold_count
    @sell_count = sell_count

    @bullish_count = bullish_count
    @bearish_count = bearish_count

    @average_opportunity_score = average_opportunity_score

    freeze
  end
end