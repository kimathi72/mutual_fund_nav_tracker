# frozen_string_literal: true

class CreateForecasts < ActiveRecord::Migration[7.1]
  def change
    create_table :forecasts do |t|
      t.references :mutual_fund,
                   null: false,
                   foreign_key: true

      t.date :forecast_date,
             null: false

      t.date :target_date,
             null: false

      t.decimal :predicted_nav,
                precision: 18,
                scale: 8

      t.decimal :lower_bound,
                precision: 18,
                scale: 8

      t.decimal :upper_bound,
                precision: 18,
                scale: 8

      t.decimal :confidence,
                precision: 8,
                scale: 4

      t.string :model_name

      t.string :model_version

      t.timestamps
    end

    add_index(
      :forecasts,
      %i[
        mutual_fund_id
        target_date
        model_name
      ],
      unique: true,
      name: "idx_forecasts_unique"
    )
  end
end