class ExecutiveFund

  attr_reader \
    :performance,
    :risk,
    :forecast,
    :executive_insight,
    :nav_history,
    :volatility_history,
    :forecast_series

  def initialize(
    performance:,
    risk:,
    forecast:,
    executive_insight:,
    nav_history:,
    volatility_history:,
    forecast_series:
  )

    @performance = performance
    @risk = risk
    @forecast = forecast
    @executive_insight = executive_insight

    @nav_history = nav_history
    @volatility_history = volatility_history
    @forecast_series = forecast_series

    freeze
  end
end