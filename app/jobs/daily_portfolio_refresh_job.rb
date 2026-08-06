class DailyPortfolioRefreshJob < ApplicationJob
  queue_as :default

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 3

  def perform(report_date = Date.current)
    Rails.logger.info(
      "[DailyPortfolioRefreshJob] Starting refresh for #{report_date}"
    )

    ImportHistoricalNavsJob.perform_now
    CalculateDailyMetricsJob.perform_now
    DatasetExportJob.perform_now
    TrainModelJob.perform_now
    GenerateForecastsJob.perform_now
    GenerateExecutiveBriefingJob.perform_now

    Rails.logger.info(
      "[DailyPortfolioRefreshJob] Completed refresh for #{report_date}"
    )
  rescue StandardError => e
    Rails.logger.error(
      "[DailyPortfolioRefreshJob] Failed for #{report_date}: #{e.message}"
    )
    raise
  end
end