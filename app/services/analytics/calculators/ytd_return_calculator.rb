# frozen_string_literal: true

module Analytics
  module Calculators
    class YtdReturnCalculator < BaseCalculator
      def call(records, index)
        current = records[index]

        first_of_year =
          records.find do |record|
            record.nav_date.year == current.nav_date.year
          end

        percentage_change(current, first_of_year)
      end
    end
  end
end