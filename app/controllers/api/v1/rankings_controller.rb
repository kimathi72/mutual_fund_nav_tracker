# frozen_string_literal: true

module Api
  module V1
    class RankingsController < BaseController
      def index
        render json:
          Reporting::Ranking::RankingReportService
            .new(limit: params.fetch(:limit, 10))
            .call
      end
    end
  end
end