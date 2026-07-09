# frozen_string_literal: true

module Analytics
  module Calculators
    class MovingAverageCalculator < BaseCalculator
      def call(records, index, window:)
        return nil if index + 1 < window

        slice = records[(index - window + 1)..index]

        total =
          slice.sum do |record|
            record.nav.to_d
          end

        total / window
      end
    end
  end
end