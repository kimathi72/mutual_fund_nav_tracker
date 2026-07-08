# frozen_string_literal: true

class ImportHistoricalNavsJob < ApplicationJob
  queue_as :market_data

  retry_on StandardError,
           wait: :exponentially_longer,
           attempts: 5

  def perform
    Rails.logger.info("[ImportHistoricalNavsJob] Starting...")

    MarketData::ImportHistoricalNavsService.new.call

    Rails.logger.info("[ImportHistoricalNavsJob] Finished.")
  end
end