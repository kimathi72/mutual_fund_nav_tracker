# frozen_string_literal: true

module Analytics
  module Calculators
    class WeeklyReturnCalculator < BaseCalculator
      WEEK = 5

      def call(records, index)
        current = records[index]
        previous = nav_at(records, index, WEEK)

        percentage_change(current, previous)
      end
    end
  end
end