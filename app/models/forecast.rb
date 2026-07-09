# frozen_string_literal: true

class Forecast < ApplicationRecord
  belongs_to :mutual_fund

  validates :target_date, presence: true

  validates :model_name, presence: true

  validates :predicted_nav,
            presence: true,
            numericality: true

  validates :confidence_score,
            numericality: true,
            allow_nil: true

  validates :mutual_fund_id,
            uniqueness: {
              scope: %i[target_date model_name]
            }

  scope :latest_first, -> { order(target_date: :desc) }

  scope :latest, -> {
    where(
      target_date: maximum(:target_date)
    )
  }
end