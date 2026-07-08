class AddAnalyticsFieldsToDailyNavs < ActiveRecord::Migration[7.1]
  def change
    add_column :daily_navs, :previous_close, :decimal, precision: 15, scale: 6
    add_column :daily_navs, :change_percent, :decimal, precision: 10, scale: 6
    add_column :daily_navs, :provider_updated_at, :date
  end
end
