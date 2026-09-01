
# frozen_string_literal: true

module Analytics
  class ReturnsCalculator
    BASELINE_DATE = Date.new(2026, 6, 30)

    attr_reader :series

    ####################################################
    # Public API
    ####################################################

    def initialize(records)
      @series = NavSeries.new(records)
    end

    def calculate
      {
        daily: daily_return,
        weekly: weekly_return,
        monthly: monthly_return,
        ytd: ytd_return,
        since_30_june_2026: return_since_30_june_2026
      }
    end

    ####################################################
    # Individual Returns
    ####################################################

    def daily_return
      return_between(
        series.previous,
        series.latest
      )
    end

    def weekly_return
      return_between(
        series.days_ago(7),
        series.latest
      )
    end

    def monthly_return
      return_between(
        series.days_ago(30),
        series.latest
      )
    end

    def ytd_return
      return_between(
        series.previous_year_end || series.year_start,
        series.latest
      )
    end

    def return_since_30_june_2026
      latest = series.latest

      return nil unless latest
      return nil if latest.date < BASELINE_DATE

      baseline =
        series.series.find do |record|
          record.date == BASELINE_DATE
        end

      return_between(
        baseline,
        latest
      )
    end

    private

    ####################################################
    # Generic Return Formula
    ####################################################

    def return_between(start_point, end_point)
      return nil unless valid_points?(start_point, end_point)

      (
        end_point.nav - start_point.nav
      ) / start_point.nav.to_d
    end

    ####################################################
    # Validation
    ####################################################

    def valid_points?(start_point, end_point)
      return false if start_point.nil?
      return false if end_point.nil?
      return false if start_point.nav.nil?
      return false if end_point.nav.nil?
      return false if start_point.nav <= 0

      true
    end
  end
end
