# frozen_string_literal: true

class GenerateExecutiveBriefingJob < ApplicationJob
  queue_as :reporting

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform
    Rails.logger.info(
      "[GenerateExecutiveBriefingJob] Starting..."
    )

    dashboard =
      Reporting::Dashboard::DashboardDataLoaderService.call

    funds =
      dashboard.funds.map do |fund|
        Reporting::Dashboard::Builders::ExecutiveFundBuilder.call(
          fund: fund
        )
      end

    summary =
      Reporting::Portfolio::PortfolioSummaryService.call(
        report_date: dashboard.report_date,
        funds: funds
      )

    portfolio_insight =
      Reporting::Insights::PortfolioExecutiveInsightService.call(
        summary: summary
      )

    response =
      Llm::ExecutiveBriefingService.call(
        summary: summary,
        portfolio_insights: portfolio_insight,
        funds: funds
      )

    unless response.present?
      Rails.logger.warn(
        "[GenerateExecutiveBriefingJob] No briefing response generated."
      )

      return
    end

    Llm::ExecutiveBriefingPersistenceService.new(
      as_of_date: summary.report_date,
      prompt: nil,
      response: response
    ).call

    Rails.logger.info(
      "[GenerateExecutiveBriefingJob] Finished."
    )
  end
end
