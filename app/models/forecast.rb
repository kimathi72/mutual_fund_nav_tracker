class Forecast < ApplicationRecord
  belongs_to :mutual_fund

  validates :target_date, presence: true
  validates :predicted_at, presence: true
  validates :model_version, presence: true

  validates :predicted_nav,
            presence: true,
            numericality: { greater_than: 0 }

  validates :confidence_score,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 1
            },
            allow_nil: true

  validates :mutual_fund_id,
            uniqueness: {
              scope: %i[
                horizon
                predicted_at
              ]
            }

  scope :latest_first,
        -> { order(predicted_at: :desc) }

  scope :with_fund,
        -> { includes(:mutual_fund) }

  scope :for_horizon,
        ->(h) { where(horizon: h) }

  scope :latest_run, lambda {
    latest_timestamp = maximum(:predicted_at)

    latest_timestamp ?
      where(predicted_at: latest_timestamp) :
      none
  }
end