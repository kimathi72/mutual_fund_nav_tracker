# frozen_string_literal: true

module Eodhd
  class HistoricalNavClient < ExternalApi::BaseClient
    def initialize
      super

      @config = Rails.configuration.x.external_services.eodhd
    end

    def fetch(symbol:, exchange:, from:, to:)
      payload = get(
        endpoint(symbol, exchange),
        query: {
          from: from,
          to: to,
          fmt: "json",
          api_token: @config.api_key
        }
      )

      Array(payload).map { |row| normalize(row, symbol, exchange) }
    end

    private

    def endpoint(symbol, exchange)
      "#{@config.base_url}/eod/#{symbol}.#{exchange}"
    end

    def normalize(row, symbol, exchange)
      {
        provider_symbol: symbol,
        provider_exchange: exchange,

        nav_date: Date.parse(row.fetch("date")),

        nav: BigDecimal(row.fetch("adjusted_close").to_s),

        currency: row["currency"],

        raw_payload: row
      }
    end
  end
end