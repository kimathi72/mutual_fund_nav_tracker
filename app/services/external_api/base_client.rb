# frozen_string_literal: true

module ExternalApi
  class BaseClient 
    include HTTParty

    private

    def get(url, query: {})
      Rails.logger.info("[#{provider_name}] GET #{url}")

      response = self.class.get(
        url,
        query: query,
        headers: headers,
        open_timeout: http_config.open_timeout,
        read_timeout: http_config.read_timeout
      )

      Rails.logger.info("[#{provider_name}] HTTP #{response.code}")

      parse_json(response)
    end

    def post(url, body:, headers: {})
      Rails.logger.info("[#{provider_name}] POST #{url}")

      response = self.class.post(
        url,
        body: body.to_json,
        headers: default_headers.merge(headers),
        open_timeout: http_config.open_timeout,
        read_timeout: http_config.read_timeout
      )

      Rails.logger.info("[#{provider_name}] HTTP #{response.code}")

      parse_json(response)
    end

    def parse_json(response)
      return [] unless response.success?

      JSON.parse(response.body)
    rescue JSON::ParserError => e
      Rails.logger.error("[#{provider_name}] #{e.message}")

      []
    end

    def default_headers
      {
        "Accept" => "application/json",
        "User-Agent" => http_config.user_agent
      }
    end

    def headers
      default_headers
    end

    def http_config
      Rails.configuration.x.external_services.http
    end

    def provider_name
      self.class.name
    end
  end
end