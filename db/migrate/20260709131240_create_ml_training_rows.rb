# frozen_string_literal: true

class CreateMlTrainingRows < ActiveRecord::Migration[7.1]
  def change
    create_table :ml_training_rows do |t|
      t.references :mutual_fund,
                   null: false,
                   foreign_key: true

      t.references :daily_nav,
                   null: false,
                   foreign_key: true

      t.date :feature_date,
             null: false

      t.decimal :nav,
                precision: 18,
                scale: 8

      t.decimal :daily_return,
                precision: 18,
                scale: 8

      t.decimal :weekly_return,
                precision: 18,
                scale: 8

      t.decimal :monthly_return,
                precision: 18,
                scale: 8

      t.decimal :ytd_return,
                precision: 18,
                scale: 8

      t.decimal :moving_average_7,
                precision: 18,
                scale: 8

      t.decimal :moving_average_30,
                precision: 18,
                scale: 8

      t.decimal :volatility_30,
                precision: 18,
                scale: 8

      t.decimal :drawdown,
                precision: 18,
                scale: 8

      # supervised learning target
      t.decimal :next_day_nav,
                precision: 18,
                scale: 8

      t.timestamps
    end

    add_index(
      :ml_training_rows,
      %i[mutual_fund_id feature_date],
      unique: true,
      name: "idx_ml_training_rows_unique"
    )
  end
end