# frozen_string_literal: true

module Ml
  class TargetCalculator
    def call(metrics, index)
      next_metric = metrics[index + 1]

      return nil unless next_metric

      next_metric.daily_nav.nav
    end
  end
end