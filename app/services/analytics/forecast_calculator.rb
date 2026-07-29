# frozen_string_literal: true

module Analytics
  class ForecastCalculator
    class << self
      def expected_return(
        current_nav,
        predicted_nav
      )
        return nil if current_nav.nil?
        return nil if predicted_nav.nil?
        return nil if current_nav.zero?

        (
          predicted_nav -
          current_nav
        ) / current_nav.to_f
      end

      def validate_bounds(
        lower:,
        prediction:,
        upper:
      )
        return false if lower.nil?
        return false if prediction.nil?
        return false if upper.nil?

        lower <= prediction &&
          prediction <= upper
      end
    end
  end
end