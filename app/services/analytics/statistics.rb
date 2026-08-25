# frozen_string_literal: true

module Analytics
  class Statistics
    class << self
      #########################################
      # Arithmetic Mean
      #########################################

      def mean(values)
        values = clean(values)

        return nil if values.empty?

        values.sum.to_f / values.length
      end

      #########################################
      # Population Variance
      #########################################

      def variance(values)
        values = clean(values)

        return nil if values.length < 2

        avg = mean(values)

        values.sum do |value|
          (value - avg)**2
        end / values.length.to_f
      end

      #########################################
      # Standard Deviation
      #########################################

      def stddev(values)
        variance_value = variance(values)

        return nil unless variance_value

        Math.sqrt(variance_value)
      end

      #########################################
      # Sample Standard Deviation
      #########################################

      def sample_stddev(values)
        values = clean(values)

        return nil if values.length < 2

        avg = mean(values)

        variance =
          values.sum do |value|
            (value - avg)**2
          end / (values.length - 1).to_f

        Math.sqrt(variance)
      end

      #########################################
      # Median
      #########################################

      def median(values)
        values = clean(values).sort

        return nil if values.empty?

        middle = values.length / 2

        if values.length.odd?
          values[middle]
        else
          (values[middle - 1] + values[middle]) / 2.0
        end
      end

      #########################################
      # Percentile
      #########################################

      def percentile(values, percentile)
        values = clean(values).sort

        return nil if values.empty?

        rank =
          percentile.to_f / 100 *
          (values.length - 1)

        lower = rank.floor
        upper = rank.ceil

        return values[lower] if lower == upper

        values[lower] +
          (values[upper] - values[lower]) *
          (rank - lower)
      end

      #########################################
      # Rolling Windows
      #########################################

      def rolling(values, window)
        values = clean(values)

        return [] if window <= 0

        values.each_cons(window).to_a
      end

      #########################################
      # Rolling Mean
      #########################################

      def rolling_mean(values, window)
        rolling(values, window).map do |slice|
          mean(slice)
        end
      end

      #########################################
      # Annualize Volatility
      #########################################

      def annualize_volatility(stddev, periods = 252)
        return nil unless stddev

        stddev * Math.sqrt(periods)
      end

      #########################################
      # Normalize
      #########################################

      def normalize(values)
        values = clean(values)

        return [] if values.empty?

        min = values.min
        max = values.max

        return Array.new(values.length, 0.5) if min == max

        values.map do |value|
          (value - min) / (max - min).to_f
        end
      end

      #########################################
      # Z Scores
      #########################################

      def z_scores(values)
        values = clean(values)

        return [] if values.empty?

        avg = mean(values)
        sd = sample_stddev(values)

        return Array.new(values.length, 0) if sd.nil? || sd.zero?

        values.map do |value|
          (value - avg) / sd
        end
      end

      private

      def clean(values)
        Array(values)
          .compact
          .map(&:to_f)
      end
    end
  end
end