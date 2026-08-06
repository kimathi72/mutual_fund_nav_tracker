# app/jobs/generate_executive_briefing_job.rb

# frozen_string_literal: true

class GenerateExecutiveBriefingJob < ApplicationJob
  queue_as :reporting

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform
    dashboard =
      Reporting::Dashboard::DashboardDataLoaderService.call

    summary =
      Reporting::Portfolio::PortfolioSummaryService.call(
        report_date: dashboard.report_date,
        funds: dashboard.funds
      )

    portfolio_insight =
      Reporting::Insights::PortfolioExecutiveInsightService.call(
        summary: summary
      )

    response =
      Llm::ExecutiveBriefingService.call(
        summary: summary,
        portfolio_insights: portfolio_insight,
        funds: dashboard.funds
      )

    return unless response.present?

    Llm::ExecutiveBriefingPersistenceService.new(
      as_of_date: summary.report_date,
      prompt: nil,
      response: response
    ).call
  rescue StandardError => e
    Rails.logger.error(
      "[GenerateExecutiveBriefingJob] Failed: #{e.message}"
    )
    raise
  end
end