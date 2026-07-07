class MutualFund < ApplicationRecord
  has_many :daily_navs, dependent: :destroy

  validates :name,
            presence: true

  validates :isin,
            presence: true,
            uniqueness: true

  validates :currency,
            presence: true

  validates :domicile,
            presence: true

  validates :figi,
            uniqueness: true,
            allow_nil: true

  scope :active, -> { where(active: true) }

  def latest_nav
    daily_navs.order(nav_date: :desc).first
  end
end