# frozen_string_literal: true

class AlignDailyNavMetricsWithMlFeatures < ActiveRecord::Migration[7.1]
  def change
    rename_column :daily_nav_metrics, :daily_return, :return_1d
    rename_column :daily_nav_metrics, :weekly_return, :return_7d
    rename_column :daily_nav_metrics, :monthly_return, :return_30d

    rename_column :daily_nav_metrics, :moving_average_7, :ma_7
    rename_column :daily_nav_metrics, :moving_average_30, :ma_30

    add_column :daily_nav_metrics,
               :ma_90,
               :decimal,
               precision: 18,
               scale: 8

    add_column :daily_nav_metrics,
               :momentum,
               :decimal,
               precision: 18,
               scale: 8

    remove_column :daily_nav_metrics,
                   :ytd_return,
                   :decimal

    remove_column :daily_nav_metrics,
                   :drawdown,
                   :decimal
  end
end