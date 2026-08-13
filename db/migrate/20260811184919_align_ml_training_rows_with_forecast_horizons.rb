# frozen_string_literal: true

class AlignMlTrainingRowsWithForecastHorizons < ActiveRecord::Migration[7.1]
  def change
    rename_column :ml_training_rows, :daily_return, :return_1d
    rename_column :ml_training_rows, :weekly_return, :return_7d
    rename_column :ml_training_rows, :monthly_return, :return_30d

    rename_column :ml_training_rows, :moving_average_7, :ma_7
    rename_column :ml_training_rows, :moving_average_30, :ma_30

    rename_column :ml_training_rows, :next_day_nav, :target_nav_1d

    add_column :ml_training_rows,
               :ma_90,
               :decimal,
               precision: 18,
               scale: 8

    add_column :ml_training_rows,
               :momentum,
               :decimal,
               precision: 18,
               scale: 8

    add_column :ml_training_rows,
               :target_nav_30d,
               :decimal,
               precision: 18,
               scale: 8

    add_column :ml_training_rows,
               :target_nav_90d,
               :decimal,
               precision: 18,
               scale: 8

    remove_column :ml_training_rows,
                   :ytd_return,
                   :decimal

    remove_column :ml_training_rows,
                   :drawdown,
                   :decimal
  end
end