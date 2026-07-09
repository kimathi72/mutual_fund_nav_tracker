# frozen_string_literal: true

module Analytics
  module Calculators
    class VolatilityCalculator < BaseCalculator
      WINDOW = 30

      def call(records, index)
        return nil if index < WINDOW

        returns = []

        (index - WINDOW + 1).upto(index) do |i|
          value =
            DailyReturnCalculator.new.call(records, i)

          returns << value.to_f if value
        end

        return nil if returns.empty?

        mean = returns.sum / returns.size

        variance =
          returns.sum do |r|
            (r - mean)**2
          end / returns.size

        Math.sqrt(variance)
      end
    end
  end
end