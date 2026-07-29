# frozen_string_literal: true

class VolatilityPointSerializer < ApplicationSerializer
  def initialize(point)
    @point = point
  end

  def as_json(*)
    {
      date: point.date,
      volatility: point.volatility
    }
  end

  private

  attr_reader :point
end