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

    def train
      post("/train")
    end

    def predict(payload)
      post("/predict", payload)
    end

    private

    def post(path, body = {})
      uri = URI("#{BASE_URL}#{path}")

      http =
        Net::HTTP.new(
          uri.host,
          uri.port
        )

      request = Net::HTTP::Post.new(uri)

      request["Content-Type"] = "application/json"

      request.body = body.to_json

      response = http.request(request)

      unless response.is_a?(Net::HTTPSuccess)
        raise response.body
      end

      JSON.parse(response.body)
    end
  end
end