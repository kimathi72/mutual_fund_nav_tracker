# frozen_string_literal: true

class PerformanceReportSerializer < ApplicationSerializer
  def initialize(report)
    @report = report
  end

  def as_json(*)
    {
      fund_id: report.fund_id,
      isin: report.isin,
      fund_name: report.fund_name,

      nav_date: report.nav_date,
      latest_nav: report.latest_nav,
      currency: report.currency,

      daily_return: report.daily_return,
      weekly_return: report.weekly_return,
      monthly_return: report.monthly_return,
      ytd_return: report.ytd_return,

      moving_average_7: report.moving_average_7,
      moving_average_30: report.moving_average_30
    }
  end

  private

  attr_reader :report
end