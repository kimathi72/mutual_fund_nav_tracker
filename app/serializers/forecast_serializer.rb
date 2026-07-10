# frozen_string_literal: true

class ForecastSerializer
  def initialize(forecast)
    @forecast = forecast
  end

  def as_json(*)
    {
      id: forecast.id,

      isin: forecast.mutual_fund.isin,
      fund_name: forecast.mutual_fund.name,

      forecast_date: forecast.forecast_date,
      target_date: forecast.target_date,

      predicted_nav: forecast.predicted_nav&.to_f,

      lower_bound: forecast.lower_bound&.to_f,
      upper_bound: forecast.upper_bound&.to_f,

      confidence: forecast.confidence_score&.to_f,

      model_version: forecast.model_version,

      created_at: forecast.created_at,
      updated_at: forecast.updated_at
    }
  end

  private

  attr_reader :forecast
end