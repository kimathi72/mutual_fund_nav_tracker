# frozen_string_literal: true

class ForecastReportSerializer
  def initialize(report)
    @report = report
  end

  def as_json
    return {} unless report

    {
      fund_id: report.fund_id,
      fund_name: report.fund_name,
      isin: report.isin,

      latest_nav: report.latest_nav,
      latest_nav_date: report.latest_nav_date,

      forecast_date: report.forecast_date,
      target_date: report.target_date,

      predicted_nav: report.predicted_nav,
      expected_change_pct: report.expected_change_pct,

      trend: report.trend,
      confidence: report.confidence,

      model_version: report.model_version
    }
  end

  private

  attr_reader :report
end