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

      "nav_history": [
          {
              "date":"2026-04-01",
              "value":1.145
          }
      ],

      "volatility_history":[
          {
              "date":"2026-04-01",
              "value":0.18
          }
      ],

      "forecast_series":[
          {
              "date":"2026-07-18",
              "value":1.162,
              "confidence":92.4
          }
      ]
    }
  end

  private

  attr_reader :fund
end