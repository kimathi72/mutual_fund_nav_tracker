# frozen_string_literal: true

class BuildTrainingDatasetJob < ApplicationJob
  queue_as :machine_learning

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform
    Ml::BuildTrainingDatasetService.new.call

    DatasetExportJob.perform_later
  end
end