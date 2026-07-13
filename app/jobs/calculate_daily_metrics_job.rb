# frozen_string_literal: true

class CalculateDailyMetricsJob < ApplicationJob
  queue_as :analytics

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

    Analytics::CalculateDailyMetricsService.new(
      scope: scope
    ).call

    BuildTrainingDatasetJob.perform_later(fund_ids)
  end
end