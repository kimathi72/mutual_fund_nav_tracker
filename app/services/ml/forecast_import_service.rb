# frozen_string_literal: true

module Ml
  class ForecastImportService
    def initialize(forecasts)
      @forecasts = forecasts
    end

    def call
      rows = []

      @forecasts.each do |fund_forecast|

        fund =
          MutualFund.find_by!(
            isin: fund_forecast["isin"]
          )

        fund_forecast["predictions"].each do |prediction|

          rows << {

            mutual_fund_id: fund.id,

            horizon: prediction["horizon"],

            predicted_at:
              fund_forecast["generated_at"],

            target_date:
              prediction["target_date"],

            predicted_nav:
              prediction["predicted_nav"],

            lower_bound:
              prediction["lower_bound"],

            upper_bound:
              prediction["upper_bound"],

            expected_return_pct:
              prediction["expected_return_pct"],

            confidence_score:
              prediction["confidence_score"],

            model_version:
              prediction["model_version"],

            created_at: Time.current,
            updated_at: Time.current
          }

        end
      end

      Forecast.upsert_all(
        rows,
        unique_by: :idx_forecasts_unique
      )

      rows.size
    end
  end
end