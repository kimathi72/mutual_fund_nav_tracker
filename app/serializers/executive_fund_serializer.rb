# frozen_string_literal: true

class ExecutiveFundSerializer < ApplicationSerializer
  def initialize(fund)
    @fund = fund
  end

  def as_json(*)
    {
      performance:
        PerformanceReportSerializer
          .new(fund.performance)
          .as_json,

      risk:
        RiskReportSerializer
          .new(fund.risk)
          .as_json,

      forecast:
        ForecastReportSerializer
          .new(fund.forecast)
          .as_json,

      executive_insight:
        ExecutiveInsightSerializer
          .new(fund.executive_insight)
          .as_json,

      nav_history:
        fund.nav_history,

      volatility_history:
        fund.volatility_history,

      forecast_series:
        fund.forecast_series
    }
  end

  private

  attr_reader :fund
end