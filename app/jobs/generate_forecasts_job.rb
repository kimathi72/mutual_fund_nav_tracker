# frozen_string_literal: true

class GenerateForecastsJob < ApplicationJob
  queue_as :machine_learning

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform(fund_ids = nil)
    scope =
      if fund_ids.present?
        MutualFund.where(id: fund_ids)
      else
        MutualFund.active
      end

    Ml::GenerateForecastsService.new(
      scope: scope
    ).call

    GenerateExecutiveBriefingJob.perform_later
  end
end