# frozen_string_literal: true

module Reporting
  module Intelligence
    class PortfolioIntelligenceService < ApplicationService
      def call
        reports =
          MutualFund
            .where(active: true)
            .order(:name)
            .map do |fund|

            forecast =
              Reporting::Forecast::ForecastReportService
                .new(fund: fund)
                .call

            insight =
              Reporting::Insights::ExecutiveInsightService
                .new(fund: fund)
                .call

            {
              fund: fund,
              forecast: forecast,
              insight: insight
            }
          end

        {
          executive_summary:
            executive_summary(reports),

          portfolio_outlook:
            portfolio_outlook(reports),

          top_opportunities:
            top_opportunities(reports),

          top_risks:
            top_risks(reports),

          buy_candidates:
            buy_candidates(reports),

          hold_candidates:
            hold_candidates(reports),

          sell_candidates:
            sell_candidates(reports)
        }
      end

      private

      def executive_summary(reports)
        bullish =
          reports.count do |r|
            r[:forecast][:trend] == "Bullish"
          end

        bearish =
          reports.count do |r|
            r[:forecast][:trend] == "Bearish"
          end

        neutral =
          reports.count do |r|
            r[:forecast][:trend] == "Neutral"
          end

        "#{bullish} bullish, #{bearish} bearish and #{neutral} neutral funds identified."
      end

      def portfolio_outlook(reports)
        bullish =
          reports.count do |r|
            r[:forecast][:trend] == "Bullish"
          end

        bearish =
          reports.count do |r|
            r[:forecast][:trend] == "Bearish"
          end

        return "Bullish" if bullish > bearish
        return "Bearish" if bearish > bullish

        "Neutral"
      end

      def top_opportunities(reports)
        reports
          .sort_by do |r|
            -(r[:forecast][:expected_change_pct] || -999)
          end
          .first(5)
          .map { |r| summary(r) }
      end

      def top_risks(reports)
        reports
          .sort_by do |r|
            r[:forecast][:expected_change_pct] || 999
          end
          .first(5)
          .map { |r| summary(r) }
      end

      def buy_candidates(reports)
        reports
          .select do |r|
            r[:insight][:recommendation] == "Buy"
          end
          .map { |r| summary(r) }
      end

      def hold_candidates(reports)
        reports
          .select do |r|
            r[:insight][:recommendation] == "Hold"
          end
          .map { |r| summary(r) }
      end

      def sell_candidates(reports)
        reports
          .select do |r|
            r[:insight][:recommendation] == "Sell"
          end
          .map { |r| summary(r) }
      end

      def summary(report)
        {
          isin: report[:fund].isin,
          fund_name: report[:fund].name,
          predicted_nav: report[:forecast][:predicted_nav],
          expected_change_pct: report[:forecast][:expected_change_pct],
          recommendation: report[:insight][:recommendation],
          trend: report[:forecast][:trend]
        }
      end
    end
  end
end