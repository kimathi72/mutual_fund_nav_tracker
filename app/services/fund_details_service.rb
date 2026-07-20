class FundDetailsService
  def initialize(fund)
    @fund = fund
  end

  def call
    {
      fund: fund,

      nav: latest_nav,

      metrics: latest_metrics,

      forecast: latest_forecast,

      nav_history: nav_history,

      volatility_history: volatility_history,

      forecast_series: forecast_series
    }
  end

  private

  attr_reader :fund

  def latest_nav
    fund.latest_daily_nav
  end

  def latest_metrics
    fund.latest_metrics
  end

  def latest_forecast
    fund.forecasts.order(target_date: :desc).first
  end

  def nav_history
    fund.daily_navs
  end

  def volatility_history
    fund.daily_nav_metrics
  end

  def forecast_series
    fund.forecasts.order(:target_date)
  end
end