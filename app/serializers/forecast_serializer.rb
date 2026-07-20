# frozen_string_literal: true

class ForecastSerializer
  def initialize(forecast)
    @forecast = forecast
  end

  def as_json(*)
    {
      id: forecast.id,


      predicted_at: forecast.predicted_at,
      target_date: forecast.target_date,
      horizon: forecast.horizon,
      predicted_nav: forecast.predicted_nav&.to_f,
      expected_return_pct: forecast.expected_return_pct&.to_f,
      lower_bound: forecast.lower_bound&.to_f,
      upper_bound: forecast.upper_bound&.to_f,

      confidence_score: forecast.confidence_score&.to_f,

      model_version: forecast.model_version,

      created_at: forecast.created_at,
      updated_at: forecast.updated_at
    }
  end

  private

  attr_reader :forecast
end