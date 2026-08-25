# frozen_string_literal: true

class DailyNavMetric < ApplicationRecord
  belongs_to :daily_nav
  belongs_to :mutual_fund
end