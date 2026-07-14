# frozen_string_literal: true

class ExecutiveFund
  attr_reader \
    :performance,
    :risk,
    :forecast,
    :executive_insight

  def initialize(
    performance:,
    risk:,
    forecast:,
    executive_insight:
  )
    @performance = performance
    @risk = risk
    @forecast = forecast
    @executive_insight = executive_insight

    freeze
  end
end