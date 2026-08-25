# frozen_string_literal: true

class DailyNav < ApplicationRecord
  belongs_to :mutual_fund

  has_one :daily_nav_metric,
          dependent: :destroy

  validates :nav_date,
            presence: true,
            uniqueness: {
              scope: :mutual_fund_id
            }

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

  scope :latest_first, -> { order(nav_date: :desc) }

  scope :between, ->(from, to) {
    where(nav_date: from..to)
  }
end