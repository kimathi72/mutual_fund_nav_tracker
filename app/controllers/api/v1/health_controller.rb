# frozen_string_literal: true

module Api
  module V1
    class HealthController < BaseController
      def show
        render_success(
          {
            status: "ok",
            environment: Rails.env,
            database: database_status,
            redis: redis_status,
            timestamp: Time.current.iso8601
          }
        )
      end

      private

      def database_status
        ActiveRecord::Base.connection.active? ? "connected" : "disconnected"
      rescue StandardError
        "disconnected"
      end

      def redis_status
        Sidekiq.redis { |redis| redis.ping == "PONG" ? "connected" : "disconnected" }
      rescue StandardError
        "disconnected"
      end
    end
  end
end