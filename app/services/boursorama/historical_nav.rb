# frozen_string_literal: true

module Boursorama
  HistoricalNav =
    Struct.new(
      :date,
      :nav,
      keyword_init: true
    )
end