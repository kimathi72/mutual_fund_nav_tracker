# frozen_string_literal: true

class ExecutiveFundHistorySerializer < ApplicationSerializer
  def initialize(history)
    @history = history
  end

  def as_json(*)
    {
      nav:
        history.nav.map do |point|
          NavPointSerializer
            .new(point)
            .as_json
        end,

      volatility:
        history.volatility.map do |point|
          VolatilityPointSerializer
            .new(point)
            .as_json
        end,

      prediction_history:
        history.prediction_history.map do |point|
          PredictionPointSerializer
            .new(point)
            .as_json
        end
    }
  end

  private

  attr_reader :history
end