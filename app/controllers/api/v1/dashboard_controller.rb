# frozen_string_literal: true

module Api
  module V1
    class DashboardController < BaseController
      def index
        dashboard =
          Reporting::Dashboard::ExecutiveDashboardService
            .new
            .call

        render json:
          DashboardSerializer
            .new(dashboard)
            .as_json
      end
    end
  end
end