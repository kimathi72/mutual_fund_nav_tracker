# frozen_string_literal: true

module Ml
  class GenerateForecastsService < ApplicationService
    MODEL_NAME = "xgboost-v1"

    def initialize(
      client: Ml::Client.new,
      scope: MutualFund.active
    )
      @client = client
      @scope = scope
    end

    def call
      Rails.logger.info(
        "[GenerateForecastsService] Starting..."
      )

      scope.find_each do |fund|
        forecast_for(fund)
      rescue => e
        Rails.logger.error(
          "[GenerateForecastsService] #{fund.isin}: #{e.message}"
        )
      end

      Rails.logger.info(
        "[GenerateForecastsService] Finished."
      )

      true
    end

    private

    attr_reader :client, :scope

    def forecast_for(fund)
      row =
        MlTrainingRow
          .where(mutual_fund: fund)
          .latest_first
          .first

      return unless row

      result =
        client.predict(
          prediction_payload(row)
        )

      Forecast.upsert(
        {
          mutual_fund_id: fund.id,

          target_date: row.feature_date + 1.day,

          model_name: MODEL_NAME,

          predicted_nav: result.fetch("prediction"),

          confidence_score: result["confidence"],

          created_at: Time.current,

          updated_at: Time.current
        },
        unique_by: :idx_forecasts_unique
      )

      Rails.logger.info(
        "[GenerateForecastsService] #{fund.isin} predicted."
      )
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