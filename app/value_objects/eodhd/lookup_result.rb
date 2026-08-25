# frozen_string_literal: true

module Eodhd
  LookupResult = Data.define(
    :instrument,
    :strategy,
    :confidence,
    :candidates
  ) do
    def found?
      instrument.present?
    end
  end
end