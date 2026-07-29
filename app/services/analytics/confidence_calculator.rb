# frozen_string_literal: true

module Analytics
  class ConfidenceCalculator
    class << self
      ####################################
      # Confidence from RMSE
      ####################################

      def from_rmse(
        rmse:,
        average_nav:
      )
        return nil if rmse.nil?
        return nil if average_nav.nil?
        return nil if average_nav.zero?

        error_ratio =
          rmse.to_f /
          average_nav.to_f

        confidence =
          1.0 - error_ratio

        confidence.clamp(0.0, 1.0)
      end

      ####################################
      # Confidence from prediction interval
      ####################################

      def from_interval(
        lower:,
        prediction:,
        upper:
      )
        return nil if lower.nil?
        return nil if prediction.nil?
        return nil if upper.nil?

        return 1.0 if prediction.to_f.zero?

        width =
          upper.to_f -
          lower.to_f

        uncertainty =
          width /
          prediction.to_f.abs

        (1.0 - uncertainty).clamp(0.0, 1.0)
      end
    end
  end
end