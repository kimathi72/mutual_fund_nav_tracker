# frozen_string_literal: true

class Forecast < ApplicationRecord
  belongs_to :mutual_fund

  validates :horizon,
            presence: true,
            inclusion: {
              in: %w[1d 30d 90d]
            }

  # target_date is intentionally nullable.
  #
  # For a live forecast, the future NAV observation does not
  # exist yet, so the ML service returns target_date: nil.

  validates :predicted_at,
            presence: true

  validates :model_version,
            presence: true

  validates :predicted_nav,
            presence: true,
            numericality: {
              greater_than: 0
            }

  validates :lower_bound,
            numericality: {
              greater_than: 0
            },
            allow_nil: true

  validates :upper_bound,
            numericality: {
              greater_than: 0
            },
            allow_nil: true

  validates :confidence_score,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 1
            },
            allow_nil: true

  validates :expected_return_pct,
            numericality: true,
            allow_nil: true
end
