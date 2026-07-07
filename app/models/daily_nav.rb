class DailyNav < ApplicationRecord
  belongs_to :mutual_fund

  validates :nav_date,
            presence: true

  validates :nav,
            presence: true,
            numericality: {
              greater_than: 0
            }

  validates :currency,
            presence: true

  validates :source,
            presence: true

  validates :fetched_at,
            presence: true

  validates :nav_date,
            uniqueness: {
              scope: :mutual_fund_id
            }

  scope :latest_first, -> { order(nav_date: :desc) }

  scope :between, ->(from, to) {
    where(nav_date: from..to)
  }
end