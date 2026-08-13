# frozen_string_literal: true

module Ml
  class TargetCalculator
    HORIZONS = {
      target_nav_1d: 1,
      target_nav_30d: 30,
      target_nav_90d: 90
    }.freeze

    def call(metrics, index)
      HORIZONS.to_h do |column, offset|
        target_metric = metrics[index + offset]

        [
          column,
          target_metric&.daily_nav&.nav
        ]
      end
    end
  end
end