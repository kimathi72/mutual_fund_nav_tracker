# frozen_string_literal: true

module Ml
  class ForecastImportService
    def initialize(forecasts)
      @forecasts = forecasts
    end

    def call
      rows = []

      @forecasts.each do |fund_forecast|
        isin = fund_forecast.fetch("isin")

        fund =
          MutualFund.find_by!(
            isin: isin
          )

        generated_at =
          Time.zone.parse(
            fund_forecast.fetch("generated_at")
          )

        predictions =
          fund_forecast.fetch("predictions", [])

        predictions.each do |prediction|
          rows << {
            mutual_fund_id: fund.id,

            horizon:
              prediction.fetch("horizon"),

            predicted_at:
              generated_at,

            # Live forecasts do not have a future NAV date yet.
            # target_date is therefore intentionally nil.
            target_date:
              prediction["target_date"].presence,

            predicted_nav:
              prediction.fetch("predicted_nav"),

            lower_bound:
              prediction["lower_bound"],

            upper_bound:
              prediction["upper_bound"],

            confidence_score:
              prediction["confidence_score"],

            expected_return_pct:
              prediction["expected_return_pct"],

            model_version:
              prediction.fetch("model_version")
          }
        end
      end

      Forecast.transaction do
        rows.each do |attributes|
          Forecast.create!(
            attributes
          )
        end
      end

      rows
    end
  end
end
