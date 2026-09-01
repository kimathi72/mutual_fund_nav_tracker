# db/migrate/XXXXXXXXXXXXXX_add_return_since_june302026_to_daily_nav_metrics.rb

# frozen_string_literal: true

class AddReturnSinceJune302026ToDailyNavMetrics < ActiveRecord::Migration[7.1]
  def change
    add_column :daily_nav_metrics,
               :return_since_30_june_2026,
               :decimal,
               precision: 12,
               scale: 8

    add_index :daily_nav_metrics,
              [:mutual_fund_id, :return_since_30_june_2026],
              name: "idx_daily_nav_metrics_fund_return_since_30_june"
  end
end