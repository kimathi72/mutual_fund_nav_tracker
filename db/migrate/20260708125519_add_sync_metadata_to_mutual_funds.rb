# frozen_string_literal: true

class AddSyncMetadataToMutualFunds < ActiveRecord::Migration[7.1]
  def change
    add_column :mutual_funds, :last_nav_date, :date
    add_column :mutual_funds, :last_market_data_sync_at, :datetime

    add_index :mutual_funds, :last_nav_date
  end
end