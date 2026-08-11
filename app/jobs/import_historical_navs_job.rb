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
      fund_ids = imported_funds.map(&:id)

      CalculateDailyMetricsJob.perform_later(fund_ids)

      Rails.logger.info(
        "[ImportHistoricalNavsJob] Queued #{fund_ids.size} updated funds."
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