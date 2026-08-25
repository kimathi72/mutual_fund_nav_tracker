class UpdateForecastSchema < ActiveRecord::Migration[7.1]
  def change
        remove_index :forecasts,
                 name: "idx_forecasts_unique"

        add_index :forecasts,
                  [:mutual_fund_id,
                  :horizon,
                  :target_date],
                  unique: true,
                  name: "idx_forecasts_unique"
  end
end
