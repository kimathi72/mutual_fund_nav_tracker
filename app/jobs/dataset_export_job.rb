# frozen_string_literal: true

class DatasetExportJob < ApplicationJob
  queue_as :machine_learning

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform(fund_ids = nil)
    Rails.logger.info(
      "[DatasetExportJob] Exporting training dataset..."
    )

    Ml::DatasetExportService.new.call

    TrainModelJob.perform_later(fund_ids)

    Rails.logger.info(
      "[DatasetExportJob] Finished. Training job queued."
    )
  end
end