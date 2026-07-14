# frozen_string_literal: true

class RankingReport
  attr_reader \
    :report_date,
    :top_ytd,
    :top_monthly,
    :top_weekly,
    :top_daily,
    :lowest_risk,
    :highest_risk,
    :largest_drawdown

  def initialize(
    report_date:,
    top_ytd:,
    top_monthly:,
    top_weekly:,
    top_daily:,
    lowest_risk:,
    highest_risk:,
    largest_drawdown:
  )
    @report_date = report_date
    @top_ytd = top_ytd
    @top_monthly = top_monthly
    @top_weekly = top_weekly
    @top_daily = top_daily
    @lowest_risk = lowest_risk
    @highest_risk = highest_risk
    @largest_drawdown = largest_drawdown

    freeze
  end
end