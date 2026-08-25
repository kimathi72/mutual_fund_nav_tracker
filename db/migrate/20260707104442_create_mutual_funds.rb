class CreateMutualFunds < ActiveRecord::Migration[7.1]
  def change
    create_table :mutual_funds do |t|
      t.string :name, null: false
      t.string :isin, null: false
      t.string :figi
      t.string :market_data_symbol
      t.string :market_data_provider

      t.string :currency, null: false
      t.string :domicile, null: false
      t.string :fund_house

      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :mutual_funds, :isin, unique: true
    add_index :mutual_funds, :figi, unique: true
    add_index :mutual_funds, :market_data_symbol
    add_index :mutual_funds, :active
  end
end