# frozen_string_literal: true

module Reporting
  class ReportingDateService < ApplicationService
    def call
      latest_metrics_date || latest_nav_date
    end

    private

    def latest_metrics_date
      DailyNavMetric
        .joins(:daily_nav)
        .maximum("daily_navs.nav_date")
    end

    def latest_nav_date
      DailyNav.maximum(:nav_date)
    end
  end
end