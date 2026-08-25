# frozen_string_literal: true

module Analytics
  class DrawdownCalculator
    attr_reader :series

    def initialize(records)
      @series = NavSeries.new(records)
    end

    def calculate
      maximum_drawdown
    end

    private

    def maximum_drawdown
      peak = -Float::INFINITY
      max_drawdown = 0

      series.series.each do |point|
        peak = [peak, point.nav].max

        drawdown =
          (
            point.nav - peak
          ) / peak.to_f

        max_drawdown =
          [
            max_drawdown,
            drawdown
          ].min
      end

      max_drawdown
    end
  end
end