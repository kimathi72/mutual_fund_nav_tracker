class RemoveColumnsFromForecasts < ActiveRecord::Migration[7.1]
  def change
    remove_column :forecasts, :forecast_date, :date
    remove_column :forecasts, :confidence, :decimal
  end
end
