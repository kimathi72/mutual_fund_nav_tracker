# frozen_string_literal: true

class AddReportingIndexes < ActiveRecord::Migration[7.1]
  def change
    add_index :daily_nav_metrics,
              [:mutual_fund_id, :ytd_return]

    add_index :daily_nav_metrics,
              [:mutual_fund_id, :monthly_return]

    add_index :daily_nav_metrics,
              [:mutual_fund_id, :volatility_30]

    add_index :daily_nav_metrics,
              [:mutual_fund_id, :drawdown]

  end
end