# frozen_string_literal: true

module ApiErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render_error(
        message: exception.message,
        status: :not_found
      )
    end

    rescue_from ActionController::ParameterMissing do |exception|
      render_error(
        message: exception.message,
        status: :bad_request
      )
    end

    rescue_from StandardError do |exception|
      Rails.logger.error(exception.full_message)

      render_error(
        message: "Internal Server Error",
        status: :internal_server_error
      )
    end
  end
end