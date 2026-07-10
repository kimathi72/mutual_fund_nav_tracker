# frozen_string_literal: true

class AddConfidenceScoreToForecasts < ActiveRecord::Migration[7.1]
  def change
    add_column :forecasts,
               :confidence_score,
               :decimal,
               precision: 8,
               scale: 6
  end
end