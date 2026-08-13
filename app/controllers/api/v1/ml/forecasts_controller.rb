# frozen_string_literal: true

module Api
  module V1
    module Ml
      class ForecastsController < ApplicationController

        # --------------------------------------------------
        # Persist newly generated forecasts
        # --------------------------------------------------

        def bulk
          forecasts = params.require(:forecasts)

          unless forecasts.is_a?(Array)
            return render json: {
              success: false,
              error: "forecasts must be an array"
            }, status: :unprocessable_entity
          end

          created = 0
          updated = 0

          Forecast.transaction do
            forecasts.each do |payload|
              result = persist_forecast(payload)

              if result == :created
                created += 1
              else
                updated += 1
              end
            end
          end

          render json: {
            success: true,
            received: forecasts.length,
            created: created,
            updated: updated
          }, status: :ok

        rescue ActionController::ParameterMissing => e
          render json: {
            success: false,
            error: e.message
          }, status: :bad_request

        rescue ActiveRecord::RecordInvalid => e
          render json: {
            success: false,
            error: e.message,
            details: e.record.errors.full_messages
          }, status: :unprocessable_entity

        rescue ActiveRecord::RecordNotFound => e
          render json: {
            success: false,
            error: e.message
          }, status: :not_found
        end

        # --------------------------------------------------
        # Persist forecast scoring results
        # --------------------------------------------------

        def score
          forecasts = params.require(:forecasts)

          unless forecasts.is_a?(Array)
            return render json: {
              success: false,
              error: "forecasts must be an array"
            }, status: :unprocessable_entity
          end

          updated = 0

          Forecast.transaction do
            forecasts.each do |payload|
              update_forecast_score(payload)
              updated += 1
            end
          end

          render json: {
            success: true,
            received: forecasts.length,
            updated: updated
          }, status: :ok

        rescue ActionController::ParameterMissing => e
          render json: {
            success: false,
            error: e.message
          }, status: :bad_request

        rescue ActiveRecord::RecordInvalid => e
          render json: {
            success: false,
            error: e.message,
            details: e.record.errors.full_messages
          }, status: :unprocessable_entity

        rescue ActiveRecord::RecordNotFound => e
          render json: {
            success: false,
            error: e.message
          }, status: :not_found
        end

        # --------------------------------------------------
        # Return forecasts ready for scoring
        # --------------------------------------------------

      def unscored
        forecasts = Forecast
          .where(actual_nav: nil)
          .where.not(target_date: nil)
          .where.not(predicted_at: nil)
          .where("target_date <= ?", Date.current)
          .includes(:mutual_fund)

        render json: {
          success: true,
          forecasts: forecasts.map do |forecast|
            {
              forecast_id: forecast.id,
              isin: forecast.mutual_fund.isin,
              horizon: forecast.horizon,
              target_date: forecast.target_date,
              predicted_at: forecast.predicted_at,
              predicted_nav: forecast.predicted_nav,
              lower_bound: forecast.lower_bound,
              upper_bound: forecast.upper_bound,
              expected_return_pct: forecast.expected_return_pct,
              origin_nav: forecast.mutual_fund.daily_navs
                .find_by(nav_date: forecast.predicted_at.to_date)
                &.nav
            }
          end
        }
      end

        private

        # --------------------------------------------------
        # Strong parameters
        # --------------------------------------------------

        def forecast_params(payload)
          payload.permit(
            :isin,
            :horizon,
            :target_date,
            :predicted_at,
            :predicted_nav,
            :lower_bound,
            :upper_bound,
            :model_version,
            :confidence_score,
            :expected_return_pct,
            :actual_nav,
            :absolute_error,
            :percentage_error,
            :direction_correct,
            :scored_at
          ).to_h.symbolize_keys
        end

        def score_params(payload)
          payload.permit(
            :forecast_id,
            :actual_nav,
            :absolute_error,
            :percentage_error,
            :direction_correct,
            :scored_at
          ).to_h.symbolize_keys
        end

        # --------------------------------------------------
        # Forecast persistence
        # --------------------------------------------------

        def persist_forecast(payload)
          payload = forecast_params(payload)

          isin = payload.fetch(:isin)

          mutual_fund = MutualFund.find_by!(
            isin: isin
          )

          forecast = Forecast.find_or_initialize_by(
            mutual_fund_id: mutual_fund.id,
            horizon: payload.fetch(:horizon),
            target_date: payload.fetch(:target_date),
            predicted_at: payload.fetch(:predicted_at)
          )

          was_new = forecast.new_record?

          forecast.assign_attributes(
            predicted_nav: payload[:predicted_nav],
            lower_bound: payload[:lower_bound],
            upper_bound: payload[:upper_bound],
            model_version: payload[:model_version],
            confidence_score: payload[:confidence_score],
            expected_return_pct: payload[:expected_return_pct],
            actual_nav: payload[:actual_nav],
            absolute_error: payload[:absolute_error],
            percentage_error: payload[:percentage_error],
            direction_correct: payload[:direction_correct],
            scored_at: payload[:scored_at]
          )

          forecast.save!

          was_new ? :created : :updated
        end

        # --------------------------------------------------
        # Forecast scoring persistence
        # --------------------------------------------------

        def update_forecast_score(payload)
          payload = payload.to_h.symbolize_keys

          forecast = Forecast.find(
            payload.fetch(:forecast_id)
          )

          forecast.update!(
            actual_nav: payload.fetch(:actual_nav),
            absolute_error: payload.fetch(:absolute_error),
            percentage_error: payload.fetch(:percentage_error),
            direction_correct: payload.fetch(:direction_correct),
            scored_at: payload.fetch(:scored_at)
          )
        end
      end
    end
  end
end