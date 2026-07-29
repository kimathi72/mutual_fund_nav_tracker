# frozen_string_literal: true

module Analytics
  class MovingAverageCalculator
    attr_reader :series

    def initialize(records)
      @series = NavSeries.new(records)
    end

    def calculate
      {
        ma7: moving_average(7),
        ma30: moving_average(30)
      }
    end

    private

    def moving_average(window)
      values =
        series
          .last_n(window)
          .map(&:nav)

      return nil if values.empty?

      Statistics.mean(values)
    end
  end
end