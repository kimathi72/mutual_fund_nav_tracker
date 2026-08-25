# frozen_string_literal: true

class MlTrainingRow < ApplicationRecord
  belongs_to :mutual_fund
  belongs_to :daily_nav

  validates :feature_date,
            presence: true

  validates :feature_date,
            uniqueness: {
              scope: :mutual_fund_id
            }

  scope :latest_first,
        -> { order(feature_date: :desc) }
end