# frozen_string_literal: true

module Analytics
  module Calculators
    class BaseCalculator < ApplicationService
      private

      def nav_at(records, index, offset)
        position = index - offset
        return nil if position.negative?

        records[position]
      end

      def percentage_change(current, previous)
        return nil if previous.nil?
        return nil if previous.nav.to_d.zero?

        (
          (current.nav.to_d - previous.nav.to_d) /
          previous.nav.to_d
        )
      end
    end
  end
end