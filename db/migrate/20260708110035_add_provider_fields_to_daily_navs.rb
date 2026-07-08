class AddProviderFieldsToDailyNavs < ActiveRecord::Migration[7.1]
  def change

    add_column :daily_navs, :provider_symbol, :string
    add_column :daily_navs, :provider_exchange, :string

    add_index :daily_navs, :provider_symbol
    add_index :daily_navs, :provider_exchange
  end
end
