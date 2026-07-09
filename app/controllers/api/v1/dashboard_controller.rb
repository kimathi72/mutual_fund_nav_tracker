# frozen_string_literal: true

module Api
  module V1
    class DashboardController < BaseController
      def index
        render json:
          Reporting::Dashboard::ExecutiveDashboardService
            .new
            .call
      end
    end
  end
end