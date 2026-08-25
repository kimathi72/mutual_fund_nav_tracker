# frozen_string_literal: true

class ForecastSerializer < ApplicationSerializer
  def initialize(prediction)
    @prediction = prediction
  end

  def as_json(*)
    {
      horizon: prediction.horizon,

      predicted_at: prediction.predicted_at,
      target_date: prediction.target_date,

      predicted_nav: prediction.predicted_nav,

      lower_bound: prediction.lower_bound,
      upper_bound: prediction.upper_bound,

      confidence_score: prediction.confidence_score,

      expected_return_pct: prediction.expected_return_pct,

      model_version: prediction.model_version,

      trend: prediction.trend,

      recommendation: prediction.recommendation
    }
  end

  private

  attr_reader :prediction
end