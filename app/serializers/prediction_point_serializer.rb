# frozen_string_literal: true

class PredictionPointSerializer < ApplicationSerializer
  def initialize(point)
    @point = point
  end

  def as_json(*)
    {
      generated_at: point.generated_at,
      target_date: point.target_date,
      horizon: point.horizon,
      predicted_nav: point.predicted_nav,
      lower_bound: point.lower_bound,
      upper_bound: point.upper_bound,
      confidence: point.confidence
    }
  end

  private

  attr_reader :point
end