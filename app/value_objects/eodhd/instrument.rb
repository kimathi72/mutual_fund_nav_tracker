# frozen_string_literal: true

module Eodhd
  Instrument = Data.define(
    :provider,
    :symbol,
    :exchange,
    :isin,
    :name,
    :security_type,
    :currency,
    :country,
    :previous_close,
    :previous_close_date
  ) do
    def eu_fund?
      exchange == "EUFUND"
    end

    def fund?
      security_type == "FUND"
    end

    def primary?
      exchange == "EUFUND"
    end
  end
end