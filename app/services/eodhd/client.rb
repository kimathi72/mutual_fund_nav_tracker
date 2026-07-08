# frozen_string_literal: true

require "bigdecimal"
require "cgi"
require "date"

module Eodhd
  class Client < ExternalApi::BaseClient
    def initialize
        super

        @config = Rails.configuration.x.external_services.eodhd
    end

    def search(query)
      get(
        "#{@config.base_url}/search/#{CGI.escape(query)}",
        query: {
          api_token: @config.api_key,
          fmt: "json"
        }
      ).map { |item| normalize(item) }
    end

    private

    def normalize(item)
      Instrument.new(
        provider: :eodhd,
        symbol: item["Code"],
        exchange: item["Exchange"],
        isin: item["ISIN"],
        name: item["Name"],
        security_type: item["Type"],
        currency: item["Currency"],
        country: item["Country"],
        previous_close: parse_decimal(item["previousClose"]),
        previous_close_date: parse_date(item["previousCloseDate"])
      )
    end

    def parse_decimal(value)
      return nil if value.blank?

      BigDecimal(value.to_s)
    end

    def parse_date(value)
      return nil if value.blank?

      Date.parse(value)
    end
  end
end