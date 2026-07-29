# frozen_string_literal: true

class GenerateForecastsJob < ApplicationJob
  queue_as :machine_learning

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform(_fund_ids = nil)
    Ml::GenerateForecastsService.call

    GenerateExecutiveBriefingJob.perform_later
  end
end