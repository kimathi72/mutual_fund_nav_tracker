# frozen_string_literal: true

module Analytics
  class NavSeries
    Observation = Struct.new(:date, :nav)

    attr_reader :series

    def initialize(records)
        @series =
            Array(records)
            .map do |record|

                date =
                if record.respond_to?(:nav_date)
                    record.nav_date
                else
                    record[:date] || record["date"]
                end

                nav =
                if record.respond_to?(:nav)
                    record.nav
                else
                    record[:nav] || record["nav"]
                end

                Observation.new(
                parse_date(date),
                nav.to_d
                )
            end
            .select do |point|
                point.date.present? &&
                point.nav.present? &&
                point.nav.positive?
            end
            .sort_by(&:date)
        end

    #############################################
    # Latest Observation
    #############################################

    def latest
      series.last
    end

    #############################################
    # First Observation
    #############################################

    def first
      series.first
    end

    #############################################
    # Previous Observation
    #############################################

    def previous
      return nil if series.length < 2

      series[-2]
    end

    #############################################
    # NAV Array
    #############################################

    def navs
      series.map(&:nav)
    end

    #############################################
    # Dates
    #############################################

    def dates
      series.map(&:date)
    end

    #############################################
    # Rolling Window
    #############################################

    def last_n(n)
      series.last(n)
    end

    #############################################
    # Closest Historical Date
    #############################################

    def closest_before(date)
      target = parse_date(date)

      series
        .reverse
        .find do |point|
          point.date <= target
        end
    end

    #############################################
    # Observation N Days Ago
    #############################################

    def days_ago(days, tolerance: 5)
      return nil unless latest

      target = latest.date - days
   
      candidate = closest_before(target)

      return nil unless candidate

      return nil if candidate.date == latest.date

      age_difference = (target - candidate.date).abs

      return nil if age_difference > tolerance

      candidate
    end

    #############################################
    # Year Start Observation
    #############################################

    def year_start
      return nil unless latest

      year =
        latest.date.year

      series.find do |point|
        point.date.year == year
      end
    end

    def previous_year_end
      return nil unless latest

      target =
        Date.new(latest.date.year - 1, 12, 31)

      closest_before(target)
    end

    #############################################
    # Daily Return Series
    #############################################

    def return_series
      returns = []

      series.each_cons(2) do |previous, current|
        next if previous.nav.zero?

        returns <<
          (
            current.nav - previous.nav
          ) / previous.nav.to_f
      end

      returns
    end

    #############################################
    # Highest NAV
    #############################################

    def peak
      navs.max
    end

    #############################################
    # Lowest NAV
    #############################################

    def trough
      navs.min
    end

    #############################################
    # Size
    #############################################

    def size
      series.length
    end

    #############################################
    # Empty?
    #############################################

    def empty?
      series.empty?
    end

    private

    def parse_date(value)
      return value if value.is_a?(Date)

      Date.parse(value.to_s)
    rescue StandardError
      nil
    end
  end
end