class CreateDailyNavMetrics < ActiveRecord::Migration[7.1]
  def change
    create_table :daily_nav_metrics do |t|
      t.references :daily_nav,
                  null: false,
                  foreign_key: true,
                  index: { unique: true }

      t.references :mutual_fund,
                  null: false,
                  foreign_key: true

      t.decimal :daily_return, precision: 12, scale: 8
      t.decimal :weekly_return, precision: 12, scale: 8
      t.decimal :monthly_return, precision: 12, scale: 8
      t.decimal :ytd_return, precision: 12, scale: 8

      t.decimal :volatility_30, precision: 12, scale: 8
      t.decimal :drawdown, precision: 12, scale: 8

      t.decimal :moving_average_7,
                precision: 18,
                scale: 6

      t.decimal :moving_average_30,
                precision: 18,
                scale: 6

      t.timestamps
    end

  end
end