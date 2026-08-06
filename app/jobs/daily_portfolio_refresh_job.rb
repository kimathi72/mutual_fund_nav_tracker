class DailyPortfolioRefreshJob < ApplicationJob
  queue_as :default

  def perform(report_date = Date.current)

    Rails.logger.info "Starting portfolio refresh #{report_date}"

    NavHistorySyncJob.perform_now(report_date)

    MetricsCalculationJob.perform_now(report_date)

    MlDatasetExportJob.perform_now(report_date)

    ForecastTrainingJob.perform_now

    ForecastGenerationJob.perform_now(report_date)

    PortfolioInsightJob.perform_now(report_date)

    ExecutiveBriefingJob.perform_now(report_date)

    Rails.logger.info "Portfolio refresh completed"

  end
end