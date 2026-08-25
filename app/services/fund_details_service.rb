# frozen_string_literal: true

class FundDetailsService < ApplicationService
  def initialize(fund)
    @fund = fund
  end

  def call
    ExecutiveFund.new(
      performance: performance,
      risk: risk,
      forecast: forecast,
      executive_insight: executive_insight,
      history: history
    )
  end

  private

  attr_reader :fund

  ##############################################
  # Reports
  ##############################################

  def performance
    @performance ||=
      Reporting::Performance::PerformanceReportService
        .new(fund: fund)
        .call
  end

  def risk
    @risk ||=
      Reporting::Risk::RiskReportService
        .new(fund: fund)
        .call
  end

  def forecast
    @forecast ||=
      Reporting::Forecast::ForecastReportService
        .new(fund: fund)
        .call
  end

  def executive_insight
    @executive_insight ||=
      Reporting::Insights::ExecutiveInsightService
        .new(
          fund: fund,
          forecast_report: forecast
        )
        .call
  end

  ##############################################
  # History
  ##############################################

 ##############################################
# History
##############################################

  def history
    ExecutiveFundHistory.new(
      nav: nav_history,
      volatility: volatility_history,
      prediction_history: prediction_history
    )
  end

  def nav_history
    fund
      .daily_navs
      .order(:nav_date)
      .map do |nav|
        NavPoint.new(
          date: nav.nav_date,
          nav: nav.nav
        )
      end
  end

  def volatility_history
    fund
      .daily_nav_metrics
      .joins(:daily_nav)
      .order("daily_navs.nav_date")
      .map do |metric|
        VolatilityPoint.new(
          date: metric.daily_nav.nav_date,
          volatility: metric.volatility_30
        )
      end
  end

  def prediction_history
    fund
      .forecasts
      .order(:target_date)
      .map do |forecast|
        PredictionPoint.new(
          generated_at: forecast.predicted_at,
          target_date: forecast.target_date,
          horizon: forecast.horizon,
          predicted_nav: forecast.predicted_nav,
          lower_bound: forecast.lower_bound,
          upper_bound: forecast.upper_bound,
          confidence: forecast.confidence_score
        )
      end
  end
end