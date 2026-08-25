class AddColumnsToForecasts < ActiveRecord::Migration[7.1]
  def change
    add_column :forecasts, :predicted_at, :datetime
    add_column :forecasts, :horizon, :string
    add_column :forecasts, :expected_return_pct, :decimal
  end
end
