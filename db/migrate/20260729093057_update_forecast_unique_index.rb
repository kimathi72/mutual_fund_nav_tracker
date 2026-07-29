class UpdateForecastUniqueIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :forecasts,
                 name: :idx_forecasts_unique

    add_index :forecasts,
              %i[
                mutual_fund_id
                horizon
                target_date
                predicted_at
              ],
              unique: true,
              name: :idx_forecasts_unique
  end
end