# frozen_string_literal: true

class ImportHistoricalNavsJob < ApplicationJob
  queue_as :market_data

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform
    Rails.logger.info(
      "[ImportHistoricalNavsJob] Starting..."
    )

    imported_funds =
      MarketData::ImportHistoricalNavsService.new.call

    if imported_funds.any?
      CalculateDailyMetricsJob.perform_later(
        imported_funds.map(&:id)
      )

      Rails.logger.info(
        "[ImportHistoricalNavsJob] Queued #{imported_funds.size} updated funds."
      )
    else
      Rails.logger.info(
        "[ImportHistoricalNavsJob] No new NAVs found."
      )
    end

    Rails.logger.info(
      "[ImportHistoricalNavsJob] Finished."
    )
  end
end