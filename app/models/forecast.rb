# app/models/forecast.rb

# frozen_string_literal: true

class Forecast < ApplicationRecord
  belongs_to :mutual_fund

  validates :horizon,
            presence: true,
            inclusion: {
              in: %w[1d 30d 90d]
            }

  validates :target_date,
            presence: true

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

  validates :actual_nav,
            numericality: {
              greater_than: 0
            },
            allow_nil: true

  validates :absolute_error,
            numericality: {
              greater_than_or_equal_to: 0
            },
            allow_nil: true

  validates :percentage_error,
            numericality: {
              greater_than_or_equal_to: 0
            },
            allow_nil: true

  validates :mutual_fund_id,
            uniqueness: {
              scope: %i[
                horizon
                target_date
                predicted_at
              ]
            }

  scope :latest_first,
        -> { order(predicted_at: :desc) }

  scope :with_fund,
        -> { includes(:mutual_fund) }

  scope :for_horizon,
        ->(horizon) {
          where(horizon: horizon)
        }

  scope :latest_run,
        lambda {
          timestamp = maximum(:predicted_at)

          timestamp ?
            where(predicted_at: timestamp) :
            none
        }

  scope :unscored,
        -> {
          where(actual_nav: nil)
            .where.not(target_date: nil)
            .where("target_date <= ?", Date.current)
        }
end