class AllowNullTargetDateOnForecasts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :forecasts, :target_date, true
  end
end
