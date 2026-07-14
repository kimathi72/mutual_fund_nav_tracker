# frozen_string_literal: true

module Reporting
  module Dashboard
    class DashboardDataLoaderService < ApplicationService
      def call
        report_date =
          Reporting::ReportingDateService.call

        funds =
          MutualFund
            .active
            .order(:name)
            .to_a

        DashboardData.new(
          report_date: report_date,
          funds: funds
        )
      end
    end
  end
end