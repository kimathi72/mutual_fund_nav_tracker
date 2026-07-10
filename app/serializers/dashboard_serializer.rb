# frozen_string_literal: true

class DashboardSerializer
  def initialize(payload)
    @payload = payload
  end

  def as_json(*)
    {
      status: "success",

      summary: payload[:summary],

      top_gainers:
        serialize_forecasts(
          payload[:top_gainers]
        ),

      top_losers:
        serialize_forecasts(
          payload[:top_losers]
        )
    }
  end

  private

  attr_reader :payload

  def serialize_forecasts(forecasts)
    forecasts.map do |forecast|
      ForecastSerializer.new(forecast).as_json
    end
  end
end