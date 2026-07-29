# frozen_string_literal: true

module Analytics
  class VolatilityCalculator
    WINDOW = 30
    TRADING_DAYS = 252

    attr_reader :series

    def initialize(records)
      @series = NavSeries.new(records)
    end

    def calculate
      observations =
        series.last_n(WINDOW)

      return nil if observations.size < 2

      returns = []

      observations.each_cons(2) do |previous, current|
        next if previous.nav.zero?

        returns <<
          (
            current.nav - previous.nav
          ) / previous.nav.to_f
      end

      return nil if returns.size < 2

      daily =
        Statistics.sample_stddev(
          returns
        )

      Statistics.annualize_volatility(
        daily,
        TRADING_DAYS
      )
    end
  end
end