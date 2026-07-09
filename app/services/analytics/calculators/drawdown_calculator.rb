# frozen_string_literal: true

module Analytics
  module Calculators
    class DrawdownCalculator < BaseCalculator
      def call(records, index)
        current = records[index]

        highest =
          records
            .first(index + 1)
            .map(&:nav)
            .max

        return nil if highest.nil?
        return nil if highest.to_d.zero?

        (
          (current.nav.to_d - highest.to_d) /
          highest.to_d
        )
      end
    end
  end
end