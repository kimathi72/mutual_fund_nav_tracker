# frozen_string_literal: true

class TrainModelJob < ApplicationJob
  queue_as :machine_learning

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform
    Ml::TrainModelService.new.call

    GenerateForecastsJob.perform_later
  end
end