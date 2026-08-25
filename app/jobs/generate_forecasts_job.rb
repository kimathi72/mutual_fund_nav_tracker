# frozen_string_literal: true

class GenerateForecastsJob < ApplicationJob
  queue_as :machine_learning

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform(fund_ids = nil)
    Rails.logger.info(
      "[GenerateForecastsJob] Generating forecasts..."
    )

    Ml::GenerateForecastsService.call

    GenerateExecutiveBriefingJob.perform_later

    Rails.logger.info(
      "[GenerateForecastsJob] Finished. Executive briefing queued."
    )
  end
end