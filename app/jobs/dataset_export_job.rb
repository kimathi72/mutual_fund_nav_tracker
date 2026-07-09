# frozen_string_literal: true

class DatasetExportJob < ApplicationJob
  queue_as :machine_learning

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform
    Ml::DatasetExportService.new.call
  end
end