# frozen_string_literal: true

class RiskReportSerializer < ApplicationSerializer
  def initialize(report)
    @report = report
  end

  def as_json(*)
    {
      fund_id: report.fund_id,
      isin: report.isin,
      fund_name: report.fund_name,

      nav_date: report.nav_date,

      volatility_30: report.volatility_30,
      drawdown: report.drawdown,

      risk_level: report.risk_level
    }
  end

  private

  attr_reader :report
end