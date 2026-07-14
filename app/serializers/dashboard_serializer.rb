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

      rankings:
        RankingSerializer
          .new(dashboard.rankings)
          .as_json,

      portfolio_insight:
        PortfolioInsightSerializer
          .new(dashboard.portfolio_insight)
          .as_json,

      briefing:
        serialize_briefing,

      funds:
        dashboard.funds.map do |fund|
          ExecutiveFundSerializer
            .new(fund)
            .as_json
        end
    }
  end

  private

  attr_reader :dashboard

  def serialize_briefing
    return nil unless dashboard.briefing

    ExecutiveBriefingSerializer
      .new(dashboard.briefing)
      .as_json
  end
end