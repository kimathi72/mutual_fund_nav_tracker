# frozen_string_literal: true

module YahooFinance
  class Client
    include HTTParty

    def initialize
        super

        @config = Rails.configuration.x.external_services.yahoo_finance
    end

    def chart(symbol)
      Rails.logger.info("[YahooFinance] Checking #{symbol}")

      response = self.class.get(
        endpoint(symbol),
        headers: headers,
        open_timeout: @config.http.open_timeout,
        read_timeout: @config.http.read_timeout
      )

      parse_response(response)
    end

    private

    def endpoint(symbol)
        url = "#{@config.yahoo_finance.base_url}#{@config.yahoo_finance.chart_endpoint}/#{symbol}"

        Rails.logger.info("[YahooFinance] URL=#{url}")

        url
    end

    def headers
      {
        "User-Agent" => @config.http.user_agent
      }
    end

    def parse_response(response)
      unless response.success?
        Rails.logger.warn("[YahooFinance] HTTP #{response.code}")
        return nil
      end

      JSON.parse(response.body)
    end
  end
end