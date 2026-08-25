# app/services/reporting/fund_time_series_service.rb

# frozen_string_literal: true

module Reporting
  class FundTimeSeriesService < ApplicationService
    HISTORY_DAYS = 90

    def initialize(fund:)
      @fund = fund
    end

    def call
      {
        nav_history: nav_history,
        volatility_history: volatility_history,
        forecast_series: forecast_series
      }
    end

    private

    attr_reader :fund

    def nav_history
      fund.daily_navs
          .last(HISTORY_DAYS)
          .map do |nav|
        {
          date: nav.nav_date,
          value: nav.nav.to_f
        }
      end
    end

    def volatility_history
      fund.daily_nav_metrics
          .last(HISTORY_DAYS)
          .map do |metric|
        {
          date: metric.daily_nav.nav_date,
          value: metric.volatility_30.to_f
        }
      end
    end

    def forecast_series
      fund.forecasts
          .last(30)
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