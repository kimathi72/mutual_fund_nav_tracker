class DailyPortfolioRefreshJob < ApplicationJob
  queue_as :default

  retry_on StandardError,
    wait: :polynomially_longer,
    attempts: 3

  def perform(report_date = Date.current)
    Rails.logger.info(
      "[DailyPortfolioRefreshJob] Starting refresh for #{report_date}"
    )

    ImportHistoricalNavsJob.perform_later

    Rails.logger.info(
      "[DailyPortfolioRefreshJob] Import pipeline queued for #{report_date}"
    )
  end
end