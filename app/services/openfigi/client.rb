# frozen_string_literal: true

module Openfigi
  class Client < ExternalApi::BaseClient
    def initialize
      @config = Rails.configuration.x.external_services.openfigi
    end

    def lookup_by_isin(isin)
      payload = post(
        endpoint,
        body: request_body(isin),
        headers: openfigi_headers
      )

      data = payload.dig(0, "data")&.first

      unless data
        Rails.logger.warn("[Openfigi::Client] No mapping found for #{isin}")
        return nil
      end

      normalize(data)
    end

    private

    def endpoint
      "#{@config.base_url}#{@config.mapping_endpoint}"
    end

    def request_body(isin)
      [
        {
          idType: "ID_ISIN",
          idValue: isin
        }
      ]
    end

    def openfigi_headers
      headers = {
        "Content-Type" => "application/json"
      }

      if @config.api_key.present?
        headers["X-OPENFIGI-APIKEY"] = @config.api_key
      end

      headers
    end

    def normalize(data)
        Openfigi::Mapping.new(
            figi: data["figi"],
            ticker: data["ticker"],
            exchange: data["exchCode"],
            security_type: data["securityType"],
            security_type2: data["securityType2"],
            market_sector: data["marketSector"],
            description: data["securityDescription"],
            name: data["name"],
            composite_figi: data["compositeFIGI"],
            share_class_figi: data["shareClassFIGI"]
        ).tap do |mapping|
            Rails.logger.info(
            "[Openfigi::Client] FIGI=#{mapping.figi} "\
            "Ticker=#{mapping.ticker}"
            )
        end
    end
  end
end