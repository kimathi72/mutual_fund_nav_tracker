# frozen_string_literal: true

class GenerateForecastsJob < ApplicationJob
  queue_as :machine_learning

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform
    Rails.logger.info(
      "[GenerateForecastsJob] Starting..."
    )

    Ml::GenerateForecastsService.new.call

    Rails.logger.info(
      "[GenerateForecastsJob] Finished."
    )
  rescue StandardError => e
    Rails.logger.error(
      "[GenerateForecastsJob] #{e.class}: #{e.message}"
    )

    raise
  end
end