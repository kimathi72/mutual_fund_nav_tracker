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

    Rails.logger.info(
      "[CalculateDailyMetricsJob] Calculating metrics for " \
      "#{scope.count} funds."
    )

    Analytics::CalculateDailyMetricsService
      .new(scope: scope)
      .call

    Rails.logger.info(
      "[CalculateDailyMetricsJob] Metrics calculated successfully " \
      "including return_since_30_june_2026."
    )

    BuildTrainingDatasetJob.perform_later(fund_ids)

    Rails.logger.info(
      "[CalculateDailyMetricsJob] Finished successfully."
    )
  end
end