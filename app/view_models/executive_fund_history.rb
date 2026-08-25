# frozen_string_literal: true

class ExecutiveFundHistory
  attr_reader :nav,
              :volatility,
              :prediction_history

  def initialize(
    nav:,
    volatility:,
    prediction_history:
  )
    @nav = nav
    @volatility = volatility
    @prediction_history = prediction_history

    freeze
  end
end