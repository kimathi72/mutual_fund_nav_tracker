class AddOpenfigiFieldsToMutualFunds < ActiveRecord::Migration[7.1]
  def change
    add_column :mutual_funds, :exchange_code, :string
    add_column :mutual_funds, :security_type, :string
    add_column :mutual_funds, :market_sector, :string

  end
end