# frozen_string_literal: true

class MutualFund < ApplicationRecord
  has_many :daily_navs, dependent: :destroy
  has_many :daily_nav_metrics, dependent: :destroy
  has_many :market_data_snapshots,
          dependent: :destroy

  has_many :ml_training_rows,
           dependent: :destroy

  has_many :forecasts,
           dependent: :destroy

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

  scope :with_latest_market_data, lambda {
    includes(daily_navs: :daily_nav_metric)
      .order(:name)
  }

  #
  # Returns the latest DailyNav.
  #
  # If daily_navs have already been eager-loaded, no SQL query is executed.
  # Otherwise falls back to a single database query.
  #
  def latest_daily_nav
    @latest_daily_nav ||= begin
      if association(:daily_navs).loaded?
        daily_navs.max_by(&:nav_date)
      else
        daily_navs.latest_first.first
      end
    end
  end

  #
  # Convenience accessor for the latest analytics.
  #
  def latest_metrics
    latest_daily_nav&.daily_nav_metric
  end
end