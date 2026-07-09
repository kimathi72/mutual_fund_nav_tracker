# frozen_string_literal: true

class Forecast < ApplicationRecord
  belongs_to :mutual_fund

  validates :forecast_date,
            presence: true

  validates :target_date,
            presence: true

  validates :predicted_nav,
            presence: true

  scope :latest_first,
        -> { order(target_date: :desc) }

  scope :latest_per_fund,
        -> {
          order(target_date: :desc)
            .select("DISTINCT ON (mutual_fund_id) forecasts.*")
        }
end