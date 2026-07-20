# frozen_string_literal: true

module Ml
  class GenerateForecastsService < ApplicationService
    def initialize(
      client: Ml::Client.new
    )
      @client = client
    end

    def call
      Rails.logger.info(
        "[GenerateForecastsService] Requesting forecast generation..."
      )

      result = client.generate_forecasts

      Rails.logger.info(
        "[GenerateForecastsService] Forecast generation completed."
      )

      Rails.logger.info(result.inspect)

      result
    rescue StandardError => e
      Rails.logger.error(
        "[GenerateForecastsService] #{e.class}: #{e.message}"
      )

      raise
    end

    private

    attr_reader :client
  end
end