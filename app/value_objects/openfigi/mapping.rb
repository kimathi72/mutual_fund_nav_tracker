# frozen_string_literal: true

module Openfigi
  Mapping = Data.define(
    :figi,
    :ticker,
    :exchange,
    :security_type,
    :security_type2,
    :market_sector,
    :description,
    :name,
    :composite_figi,
    :share_class_figi
  )
end