require 'rails_helper'

RSpec.describe Ml::DatasetExportService, type: :service do
  describe '#call' do
    it 'exports a feature-rich dataset with metric and lag columns' do
      fund = create(:mutual_fund, isin: 'LU0000000001')
      daily_nav = create(:daily_nav, mutual_fund: fund, nav_date: Date.new(2026, 1, 2), nav: 100.0)
      create(:daily_nav_metric, daily_nav: daily_nav, mutual_fund: fund, daily_return: 0.01, weekly_return: 0.02, monthly_return: 0.03, ytd_return: 0.04, volatility_30: 0.05, drawdown: -0.01, moving_average_7: 100.5, moving_average_30: 101.0)

      path = Rails.root.join('tmp', 'dataset_export_spec.csv')
      FileUtils.rm_f(path)

      service = described_class.new(path: path)
      service.call

      expect(path).to exist

      rows = CSV.read(path, headers: true)
      expect(rows.headers).to include('isin', 'nav_date', 'nav', 'daily_return', 'weekly_return', 'monthly_return', 'ytd_return', 'volatility_30', 'drawdown', 'moving_average_7', 'moving_average_30', 'lag_1', 'lag_5', 'lag_20')
      expect(rows.first['isin']).to eq('LU0000000001')
      expect(rows.first['daily_return']).to eq('0.01')
    end
  end
end
