# frozen_string_literal: true

module Api
  module V1
    class FundsController < BaseController
      def index
        render_success(
          MutualFund
            .active
            .with_latest_market_data
            .map do |fund|
              details =
                FundDetailsService
                  .new(fund)
                  .call

              ExecutiveFundSerializer
                .new(details)
                .as_json
            end
        )
      end

      def show
        fund =
          MutualFund
            .with_latest_market_data
            .find(params[:id])

        details =
          FundDetailsService
            .new(fund)
            .call
        puts "Details: #{details}"
        render_success(
          ExecutiveFundSerializer
            .new(details)
            .as_json
        )
      end
    end
  end
end