# frozen_string_literal: true

class ExecutiveBriefing < ApplicationRecord
  validates :as_of_date,
            :provider,
            :model,
            :generated_at,
            :status,
            presence: true

  validates :status,
            inclusion: {
              in: %w[
                success
                failed
              ]
            }

  scope :latest, -> { order(as_of_date: :desc) }
end