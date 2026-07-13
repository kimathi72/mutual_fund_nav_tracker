# frozen_string_literal: true

module Ml
  class GenerateForecastsService < ApplicationService
    MODEL_VERSION = "xgboost-v1"

    def initialize(
      scope: MutualFund.active,
      prediction_client: Ml::PredictionClient.new
    )
      @scope = scope
      @prediction_client = prediction_client
    end

    def call
      Rails.logger.info(
        "[GenerateForecastsService] Processing #{scope.size} fund(s)..."
      )

      generated = 0

      each_fund do |fund|
        generated += 1 if forecast_for(fund)
      rescue StandardError => e
        Rails.logger.error(
          "[GenerateForecastsService] #{fund.isin} - #{e.class}: #{e.message}"
        )
      end

      Rails.logger.info(
        "[GenerateForecastsService] Finished. #{generated} forecast(s) generated."
      )

      true
    end

    private

    attr_reader :scope,
                :prediction_client

    def each_fund(&block)
      if scope.respond_to?(:find_each)
        scope.find_each(&block)
      else
        Array(scope).each(&block)
      end
    end

    def forecast_for(fund)
      row =
        MlTrainingRow
          .where(mutual_fund: fund)
          .latest_first
          .first

      unless row
        Rails.logger.warn(
          "[GenerateForecastsService] #{fund.isin} has no training row."
        )

        return false
      end

      response =
        prediction_client.predict(
          prediction_payload(row)
        )

      prediction = response["prediction"]

      if prediction.blank?
        Rails.logger.warn(
          "[GenerateForecastsService] #{fund.isin} returned no prediction."
        )

        return false
      end

      timestamp = Time.current

      Forecast.upsert(
        {
          mutual_fund_id: fund.id,
          forecast_date: row.feature_date,
          target_date: row.feature_date + 1.day,
          model_version: MODEL_VERSION,
          predicted_nav: prediction,
          confidence_score: response["confidence"],
          created_at: timestamp,
          updated_at: timestamp
        },
        unique_by: :idx_forecasts_unique
      )

      Rails.logger.info(
        "[GenerateForecastsService] #{fund.isin} => #{prediction.round(4)}"
      )

      true
    end

    def prediction_payload(row)
      {
        nav: row.nav,
        daily_return: row.daily_return,
        weekly_return: row.weekly_return,
        monthly_return: row.monthly_return,
        ytd_return: row.ytd_return,
        moving_average_7: row.moving_average_7,
        moving_average_30: row.moving_average_30,
        volatility_30: row.volatility_30,
        drawdown: row.drawdown
      }
    end
  end
end