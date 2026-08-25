# frozen_string_literal: true

class AddUniqueIndexToForecasts < ActiveRecord::Migration[7.1]
  def change
    add_index :forecasts,
              %i[
                mutual_fund_id
                target_date
                model_version
              ],
              unique: true,
              name: :idx_forecasts_unique
  end
end