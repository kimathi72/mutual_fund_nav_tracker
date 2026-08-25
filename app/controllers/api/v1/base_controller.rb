# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      include ApiErrorHandler

      before_action :set_default_headers

      private

      def render_success(data = {}, status: :ok)
        render json: {
          success: true,
          generated_at: Time.current.iso8601,
          api_version: "v1",
          data: data
        }, status: status
      end

      def render_error(message:, status:)
        render json: {
          success: false,
          generated_at: Time.current.iso8601,
          api_version: "v1",
          error: {
            message: message,
            status: Rack::Utils.status_code(status)
          }
        }, status: status
      end

      def set_default_headers
        response.set_header("X-API-Version", "v1")
        response.set_header("Content-Type", "application/json")
      end
    end
  end
end