# frozen_string_literal: true

class VolatilityPoint
  attr_reader :date,
              :volatility

  def initialize(
    date:,
    volatility:
  )
    @date = date
    @volatility = volatility

    freeze
  end
end