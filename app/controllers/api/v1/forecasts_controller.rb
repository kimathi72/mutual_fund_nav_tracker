# frozen_string_literal: true

module Api
  module V1
    class ForecastsController < ApplicationController
      def index
        forecasts =
          Forecast
            .with_fund
            .latest_first

        render json: {
          status: "success",
          count: forecasts.size,
          data: ApplicationSerializer.collection(
            forecasts,
            ForecastSerializer
          )
        }
      end

      def latest
        forecasts =
          Forecast
            .with_fund
            .latest
            .order(:mutual_fund_id)

        render json: {
          status: "success",
          count: forecasts.size,
          data: ApplicationSerializer.collection(
            forecasts,
            ForecastSerializer
          )
        }
      end

      def bulk
        imported =
          Ml::ForecastImportService.new(
            params.require(:forecasts)
          ).call

        render json: {
          status: "success",
          imported: imported
        }, status: :created
      end

      def show
        fund =
          MutualFund.find_by!(
            isin: params[:isin]
          )

        forecasts =
          fund.forecasts
              .latest_first

        render json: {
          status: "success",
          isin: fund.isin,
          fund_name: fund.name,
          count: forecasts.size,
          data: ApplicationSerializer.collection(
            forecasts,
            ForecastSerializer
          )
        }
      end
    end
  end
end