# frozen_string_literal: true

module ExternalApi
  class BaseClient < ApplicationService
    include HTTParty

    def initialize
        @http_config =
            Rails.configuration.x.external_services.http ||
            ActiveSupport::OrderedOptions.new.tap do |config|
            config.open_timeout = 5
            config.read_timeout = 20
            config.user_agent = "MutualFundNavTracker/1.0"
            end
    end

    private

    attr_reader :http_config

    def get(url, query: {}, headers: {})
      Rails.logger.info("[#{self.class.name}] GET #{url}")

      response = self.class.get(
        url,
        query: query,
        headers: default_headers.merge(headers),
        open_timeout: http_config.open_timeout,
        read_timeout: http_config.read_timeout
      )

      Rails.logger.info("[#{self.class.name}] HTTP #{response.code}")

      parse_response(response)
    end

    def post(url, body:, headers: {})
      Rails.logger.info("[#{self.class.name}] POST #{url}")

      response = self.class.post(
        url,
        body: body.to_json,
        headers: default_headers.merge(headers),
        open_timeout: http_config.open_timeout,
        read_timeout: http_config.read_timeout
      )

      Rails.logger.info("[#{self.class.name}] HTTP #{response.code}")

      parse_response(response)
    end

    def default_headers
      {
        "User-Agent" => http_config.user_agent,
        "Content-Type" => "application/json"
      }
    end

    def parse_response(response)
      return [] if response.code == 404

      unless response.success?
        raise StandardError,
              "#{self.class.name} request failed (HTTP #{response.code})"
      end

      JSON.parse(response.body)
    end
  end
end