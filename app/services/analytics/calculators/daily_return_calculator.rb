# frozen_string_literal: true

module Analytics
  module Calculators
    class DailyReturnCalculator < BaseCalculator
      def call(records, index)
        current = records[index]
        previous = nav_at(records, index, 1)

        percentage_change(current, previous)
      end
    end
  end
end