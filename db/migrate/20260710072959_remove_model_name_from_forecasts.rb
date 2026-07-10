# frozen_string_literal: true

class RemoveModelNameFromForecasts < ActiveRecord::Migration[7.1]
  def change
    remove_column :forecasts,
                  :model_name,
                  :string
  end
end