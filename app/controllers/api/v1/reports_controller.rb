# frozen_string_literal: true

module Api
  module V1
    class ReportsController < BaseController
      def portfolio
        render json:
          Reporting::Portfolio::PortfolioSummaryService
            .new
            .call
      end

      def rankings
        render json:
          Reporting::Ranking::RankingReportService
            .new
            .call
      end

      def performance
        fund = MutualFund.find(params[:fund_id])

        render json:
          Reporting::Performance::PerformanceReportService
            .new(fund: fund)
            .call
      end

      def risk
        fund = MutualFund.find(params[:fund_id])

        render json:
          Reporting::Risk::RiskReportService
            .new(fund: fund)
            .call
      end
    end
  end
end