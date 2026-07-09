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

    success =
      MarketData::ImportHistoricalNavsService.new.call

    if success
      CalculateDailyMetricsJob.perform_later

      Rails.logger.info(
        "[ImportHistoricalNavsJob] Analytics job queued."
      )
    end

    Rails.logger.info(
      "[ImportHistoricalNavsJob] Finished."
    )
  end
end