# frozen_string_literal: true

module Reporting
  module Portfolio
    class PortfolioSummaryService < ApplicationService
      def initialize(
        report_date:,
        funds:
      )
        @report_date = report_date
        @funds = funds
      end

      def call
        return empty_summary if funds.empty?

        PortfolioSummary.new(
          report_date: report_date,
          total_funds: funds.size,

          average_daily_return: average(:daily_return),
          average_weekly_return: average(:weekly_return),
          average_monthly_return: average(:monthly_return),
          average_ytd_return: average(:ytd_return),
          average_volatility: average(:volatility),

          best_performer: portfolio_summary(funds.max_by(&:ytd_return)),
          worst_performer: portfolio_summary(funds.min_by(&:ytd_return)),
          highest_risk: portfolio_summary(funds.max_by(&:volatility)),
          lowest_risk: portfolio_summary(funds.min_by(&:volatility)),
          buy_count: funds.count { |f| f.recommendation == "Buy" },
          hold_count: funds.count { |f| f.recommendation == "Hold" },
          sell_count: funds.count { |f| f.recommendation == "Sell" },

          bullish_count: funds.count { |f| f.market_outlook == "Bullish" },
          bearish_count: funds.count { |f| f.market_outlook == "Bearish" },

          average_opportunity_score:
            average_from(funds, :opportunity_score)
        )
      end

      private

      attr_reader :report_date, :funds

      def average(attribute)
        values =
          funds
            .map(&attribute)
            .compact

        return nil if values.empty?

        values.sum.to_d / values.size
      end
      def average_from(records, attribute)
        values = records.map(&attribute).compact
        return nil if values.empty?

        values.sum.to_d / values.size
      end

      def portfolio_summary(fund)
        return nil unless fund

        PortfolioFundSummary.new(
          fund_id: fund.fund_id,
          fund_name: fund.fund_name,
          isin: fund.isin,
          nav: fund.nav,
          ytd_return: fund.ytd_return,
          volatility: fund.volatility,
          drawdown: fund.drawdown
        )
      end

      def empty_summary
        PortfolioSummary.new(
          report_date: report_date,
          total_funds: 0,
          average_daily_return: nil,
          average_weekly_return: nil,
          average_monthly_return: nil,
          average_ytd_return: nil,
          average_volatility: nil,
          best_performer: nil,
          worst_performer: nil,
          highest_risk: nil,
          lowest_risk: nil,
          buy_count: 0,
          hold_count: 0,
          sell_count: 0,

          bullish_count: 0,
          bearish_count: 0,

          average_opportunity_score: 0
        )
      end
    end
  end
end