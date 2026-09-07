
# frozen_string_literal: true

require "net/http"
require "json"

module Ml
  class Client
    BASE_URL =
      ENV.fetch(
        "ML_SERVICE_URL",
        "http://ml:8000"
      )

    OPEN_TIMEOUT =
      ENV.fetch(
        "ML_OPEN_TIMEOUT",
        5
      ).to_i

    READ_TIMEOUT =
      ENV.fetch(
        "ML_READ_TIMEOUT",
        600
      ).to_i

    #
    # Train all horizons.
    #
    def train
      post("/train")
    end

    #
    # Generate forecasts for every active fund.
    #
    def generate_forecasts
      post("/forecast")
    end

    private

    def post(path, body = {})
      uri = URI("#{BASE_URL}#{path}")

      http =
        Net::HTTP.new(
          uri.host,
          uri.port
        )

      http.open_timeout = OPEN_TIMEOUT
      http.read_timeout = READ_TIMEOUT

      request =
        Net::HTTP::Post.new(uri)

      request["Content-Type"] =
        "application/json"

      request.body =
        body.to_json

      Rails.logger.info(
        "[Ml::Client] POST #{uri} " \
        "(open_timeout=#{OPEN_TIMEOUT}s, " \
        "read_timeout=#{READ_TIMEOUT}s)"
      )

      response =
        http.request(request)

      unless response.is_a?(Net::HTTPSuccess)
        raise StandardError,
              "ML service request failed " \
              "(HTTP #{response.code}): #{response.body}"
      end

      JSON.parse(response.body)
    end
  end
end
