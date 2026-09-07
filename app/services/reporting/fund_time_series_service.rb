
module Reporting
  class FundTimeSeriesService < ApplicationService
    BASELINE_DATE = Date.new(2026, 6, 30)

    def initialize(
      fund:,
      from_date: BASELINE_DATE,
      to_date: nil
    )
      @fund = fund
      @from_date = from_date
      @to_date = to_date
    end

    def call
      {
        nav_history: nav_history,
        volatility_history: volatility_history,
        forecast_series: forecast_series
      }
    end

    private

    attr_reader :fund, :from_date, :to_date

    def effective_to_date
      to_date || fund.daily_navs.maximum(:nav_date)
    end

    def nav_history
      fund.daily_navs
        .where(
          nav_date: from_date..effective_to_date
        )
        .order(:nav_date)
        .map do |nav|
          {
            date: nav.nav_date,
            value: nav.nav.to_f
          }
        end
    end

    def volatility_history
      fund.daily_nav_metrics
        .joins(:daily_nav)
        .where(
          daily_navs: {
            nav_date: from_date..effective_to_date
          }
        )
        .order("daily_navs.nav_date ASC")
        .map do |metric|
          {
            date: metric.daily_nav.nav_date,
            value: metric.volatility_30.to_f
          }
        end
    end

    def forecast_series
      fund.forecasts
        .where(
          target_date: from_date..(effective_to_date + 30.days)
        )
        .order(:target_date)
        .map do |forecast|
          {
            date: forecast.target_date,
            value: forecast.predicted_nav.to_f,
            confidence: forecast.confidence_score.to_f
          }
        end
    end
  end
end
