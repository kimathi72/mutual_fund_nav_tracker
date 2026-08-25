# frozen_string_literal: true

class ExecutiveFund
  attr_reader :performance,
              :risk,
              :forecast,
              :executive_insight,
              :history

  def initialize(
    performance:,
    risk:,
    forecast:,
    executive_insight:,
    history:
  )

    @performance = performance
    @risk = risk
    @forecast = forecast
    @executive_insight = executive_insight
    @history = history

    freeze
  end
end