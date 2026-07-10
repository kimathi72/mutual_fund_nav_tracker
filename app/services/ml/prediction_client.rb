# frozen_string_literal: true

require "net/http"
require "json"

module Ml
  class PredictionClient < ApplicationService
    ML_URL =
      ENV.fetch(
        "ML_SERVICE_URL",
        "http://localhost:8000"
      )

    def initialize(metric:)
      @metric = metric
    end

    def call
      response =
        Net::HTTP.post(
          predict_uri,
          payload.to_json,
          "Content-Type" => "application/json"
        )

      raise response.body unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)
    end

    private

    attr_reader :metric

    def predict_uri
      URI("#{ML_URL}/predict")
    end

    def payload
      {
        nav: metric.daily_nav.nav.to_f,
        daily_return: metric.daily_return.to_f,
        weekly_return: metric.weekly_return.to_f,
        monthly_return: metric.monthly_return.to_f,
        ytd_return: metric.ytd_return.to_f,
        moving_average_7: metric.moving_average_7.to_f,
        moving_average_30: metric.moving_average_30.to_f,
        volatility_30: metric.volatility_30.to_f,
        drawdown: metric.drawdown.to_f
      }
    end
  end
end