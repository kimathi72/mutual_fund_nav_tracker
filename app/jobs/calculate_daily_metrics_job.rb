# frozen_string_literal: true

class CalculateDailyMetricsJob < ApplicationJob
  queue_as :analytics

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform
    Rails.logger.info(
      "[CalculateDailyMetricsJob] Starting..."
    )

    Analytics::CalculateDailyMetricsService.new.call

    BuildTrainingDatasetJob.perform_later

    Rails.logger.info(
      "[CalculateDailyMetricsJob] Finished."
    )
  end
end