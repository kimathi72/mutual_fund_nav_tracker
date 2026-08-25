require 'rails_helper'

RSpec.describe GenerateExecutiveBriefingJob, type: :job do
  describe '#perform' do
    it 'persists a briefing summary when the LLM service returns content' do
      dashboard = instance_double(
        'DashboardDataLoaderServiceResult',
        report_date: Date.new(2026, 7, 17),
        funds: [instance_double('Fund', id: 1, name: 'Alpha Fund')]
      )

      summary = instance_double(
        'PortfolioSummary',
        report_date: Date.new(2026, 7, 17)
      )

      portfolio_insight = instance_double(
        'PortfolioExecutiveInsight',
        portfolio_health: 'Strong',
        market_sentiment: 'Bullish',
        portfolio_risk: 'Low',
        executive_recommendation: 'Maintain current allocation.'
      )

      allow(Reporting::Dashboard::DashboardDataLoaderService).to receive(:call).and_return(dashboard)
      allow(Reporting::Portfolio::PortfolioSummaryService).to receive(:call).and_return(summary)
      allow(Reporting::Insights::PortfolioExecutiveInsightService).to receive(:call).and_return(portfolio_insight)

      briefing = instance_double(
        'ExecutiveBriefingResult',
        briefing: 'Portfolio overview generated',
        generated_at: Time.current,
        error: nil,
        generated_by: 'test-provider'
      )

      allow(Llm::ExecutiveBriefingService).to receive(:call).and_return(briefing)

      expect { described_class.new.perform }.to change(ExecutiveBriefing, :count).by(1)

      persisted = ExecutiveBriefing.last
      expect(persisted.as_of_date).to eq(Date.new(2026, 7, 17))
      expect(persisted.briefing).to eq('Portfolio overview generated')
      expect(persisted.status).to eq('success')
    end
  end
end
