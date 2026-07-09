# frozen_string_literal: true

module Api
  module V1
    class FundsController < BaseController
      def index
        render_success(
          MutualFund
            .active
            .with_latest_market_data
            .map { |fund| FundSerializer.new(fund).as_json }
        )
      end

      def show
        fund =
          MutualFund
            .with_latest_market_data
            .find(params[:id])

        render_success(
          FundSerializer.new(fund).as_json
        )
      end
    end
  end
end