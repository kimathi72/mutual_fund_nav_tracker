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
            .where.not(:last_nav_date => nil)
            .preload(
              :daily_navs,
              :forecasts,
              daily_nav_metrics: :daily_nav
            )
            .order(:name)
            
            
        funds.each do |fund|
          series = Reporting::FundTimeSeriesService.call(fund: fund)

          fund.define_singleton_method(:nav_history) do
            series[:nav_history]
          end

          fund.define_singleton_method(:volatility_history) do
            series[:volatility_history]
          end

          fund.define_singleton_method(:forecast_series) do
            series[:forecast_series]
          end
        end

        DashboardData.new(
          report_date: report_date,
          funds: funds
        )
      end
    end
  end
end