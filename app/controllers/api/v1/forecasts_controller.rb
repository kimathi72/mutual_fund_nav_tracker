# frozen_string_literal: true

module Api
  module V1
    class ForecastsController < BaseController
      def index
        forecasts =
          Forecast
            .with_fund
            .latest_first

        render_success(
          data: ApplicationSerializer.collection(
            forecasts,
            ForecastSerializer
          )
        )
      end

      def latest
        forecasts =
          Forecast
            .with_fund
            .latest_run
            .order(:mutual_fund_id)

        render_success(
          data: ApplicationSerializer.collection(
            forecasts,
            ForecastSerializer
          )
        )
      end

      def show
        fund =
          MutualFund.find_by!(
            isin: params[:id]
          )

        forecasts =
          fund.forecasts.latest_first

        render_success(
          data: ApplicationSerializer.collection(
            forecasts,
            ForecastSerializer
          )
        )
      end
    end
  end
end