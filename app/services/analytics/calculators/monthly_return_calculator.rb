# frozen_string_literal: true

module Analytics
  module Calculators
    class MonthlyReturnCalculator < BaseCalculator
      MONTH = 21

      def call(records, index)
        current = records[index]
        previous = nav_at(records, index, MONTH)

        percentage_change(current, previous)
      end
    end
  end
end