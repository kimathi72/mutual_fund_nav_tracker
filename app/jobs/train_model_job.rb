# frozen_string_literal: true

class TrainModelJob < ApplicationJob
  queue_as :machine_learning

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform(fund_ids = nil)
    Rails.logger.info(
      "[TrainModelJob] Training models..."
    )

    Ml::TrainModelService.new.call

    GenerateForecastsJob.perform_later(fund_ids)

    Rails.logger.info(
      "[TrainModelJob] Finished. Forecast job queued."
    )
  end
end