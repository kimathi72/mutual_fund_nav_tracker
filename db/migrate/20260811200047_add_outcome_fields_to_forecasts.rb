# frozen_string_literal: true

class AddOutcomeFieldsToForecasts < ActiveRecord::Migration[7.1]
  def change
    add_column :forecasts,
                :actual_nav,
                :decimal,
                precision: 18,
                scale: 8

    add_column :forecasts,
                :absolute_error,
                :decimal,
                precision: 18,
                scale: 8

    add_column :forecasts,
                :percentage_error,
                :decimal,
                precision: 18,
                scale: 8

    add_column :forecasts,
                :direction_correct,
                :boolean

    add_column :forecasts,
                :scored_at,
                :datetime

    add_index :forecasts,
              :scored_at

    add_index :forecasts,
              [:target_date, :scored_at]
  end
end