# frozen_string_literal: true

module Reporting
  module Dashboard
    class DashboardDataLoaderService < ApplicationService
      def call
        DashboardData.new(
          report_date: report_date,
          funds: funds
        )
      end

      private

      def report_date
        @report_date ||=
          Reporting::ReportingDateService.call
      end

      def funds
        @funds ||=
          MutualFund
            .active
            .where.not(last_nav_date: nil)
            .includes(
              :daily_navs,
              :forecasts,
              daily_nav_metrics: :daily_nav
            )
            .order(:name)
            .to_a
      end
    end
  end
end