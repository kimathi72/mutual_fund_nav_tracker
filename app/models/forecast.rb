# frozen_string_literal: true

class Forecast < ApplicationRecord
  belongs_to :mutual_fund

  validates :target_date,
            presence: true

  validates :model_version,
            presence: true

  validates :predicted_nav,
            presence: true,
            numericality: {
              greater_than: 0
            }

  validates :confidence_score,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 1
            },
            allow_nil: true

  validates :mutual_fund_id,
            uniqueness: {
              scope: %i[
                target_date
                model_version
              ]
            }

  scope :latest_first, -> { order(target_date: :desc) }
  scope :with_fund, -> { includes(:mutual_fund) }
  scope :latest, lambda {
    latest_date = maximum(:target_date)

    latest_date ? where(target_date: latest_date) : none
  }
end