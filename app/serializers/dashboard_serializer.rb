# frozen_string_literal: true

class DashboardSerializer < ApplicationSerializer
  def initialize(dashboard)
    @dashboard = dashboard
  end

  def as_json(*)
    {
      generated_at: dashboard.generated_at,

      summary:
        PortfolioSummarySerializer
          .new(dashboard.summary)
          .as_json,

      rankings: dashboard.rankings,

      portfolio_insight:
        serialize_portfolio_insight,

      briefing:
        serialize_briefing,

      funds:
        serialize_funds
    }
  end

  private

  attr_reader :dashboard

  def serialize_portfolio_insight
    return nil unless dashboard.portfolio_insight

    PortfolioInsightSerializer
      .new(dashboard.portfolio_insight)
      .as_json
  end

  def serialize_briefing
    return nil unless dashboard.briefing

    ExecutiveBriefingSerializer
      .new(dashboard.briefing)
      .as_json
  end

  def serialize_funds
    dashboard.funds.map do |fund|
      ForecastReportSerializer
        .new(fund[:forecast])
        .as_json
    end
  end
end