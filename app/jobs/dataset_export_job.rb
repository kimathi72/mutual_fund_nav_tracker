# frozen_string_literal: true

class DatasetExportJob < ApplicationJob
  queue_as :machine_learning

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform(fund_ids = nil)
    Ml::DatasetExportService.new.call

    TrainModelJob.perform_later(fund_ids)
  end
end