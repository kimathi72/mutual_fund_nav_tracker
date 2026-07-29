# frozen_string_literal: true

module Reporting
  module Ranking
    class RankingReportService < ApplicationService
      DEFAULT_LIMIT = 10

      def initialize(
        report_date:,
        funds:,
        limit: DEFAULT_LIMIT
      )
        @report_date = report_date
        @funds = funds
        @limit = limit
      end

      def call
        return empty_report if funds.empty?

        RankingReport.new(
          report_date: report_date,
          top_ytd: rankings(top(:ytd_return)),
          top_monthly: rankings(top(:monthly_return)),
          top_weekly: rankings(top(:weekly_return)),
          top_daily: rankings(top(:daily_return)),
          lowest_risk: rankings(bottom(:volatility)),
          highest_risk: rankings(top(:volatility)),
          largest_drawdown: rankings(bottom(:drawdown))
        )
      end

      private

      attr_reader :report_date, :funds, :limit

      def top(attribute)
        funds
          .select { |f| f.public_send(attribute).present? }
          .sort_by { |f| -f.public_send(attribute).to_f }
          .first(limit)
      end

      def bottom(attribute)
        funds
          .select { |f| f.public_send(attribute).present? }
          .sort_by { |f| f.public_send(attribute).to_f }
          .first(limit)
      end

      def rankings(records)
        records.each_with_index.map do |fund, index|
          FundRanking.new(
            rank: index + 1,

            fund_id: fund.fund_id,
            fund_name: fund.fund_name,
            isin: fund.isin,

            nav: fund.nav,
            currency: fund.currency,

            daily_return: fund.daily_return,
            weekly_return: fund.weekly_return,
            monthly_return: fund.monthly_return,
            ytd_return: fund.ytd_return,

            volatility: fund.volatility,
            drawdown: fund.drawdown
          )
        end
      end

      def empty_report
        RankingReport.new(
          report_date: report_date,
          top_ytd: [],
          top_monthly: [],
          top_weekly: [],
          top_daily: [],
          lowest_risk: [],
          highest_risk: [],
          largest_drawdown: []
        )
      end
    end
  end
end