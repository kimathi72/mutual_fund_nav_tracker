# frozen_string_literal: true

module Analytics
  class CalculateDailyMetricsService < ApplicationService
    LOOKBACK_DAYS = 35
    INITIAL_IMPORT_DATE = Date.new(2025, 1, 1)

    def initialize(scope: MutualFund.where(active: true))
      @scope = scope
    end

    def call
      Rails.logger.info(
        "[CalculateDailyMetricsService] Processing #{scope.size} funds..."
      )

      each_fund do |fund|
        calculate_for_fund(fund)
      rescue => e
        Rails.logger.error(
          "[CalculateDailyMetricsService] #{fund.isin}: #{e.class} #{e.message}"
        )
      end

      Rails.logger.info(
        "[CalculateDailyMetricsService] Finished."
      )

      true
    end

    private

    attr_reader :scope

    def each_fund(&block)
      if scope.respond_to?(:find_each)
        scope.find_each(&block)
      else
        Array(scope).each(&block)
      end
    end

    #######################################################

    def calculate_for_fund(fund)
      latest_nav_date =
        fund.daily_navs.maximum(:nav_date)

      return false unless latest_nav_date

      last_metric_date =
        DailyNavMetric
          .joins(:daily_nav)
          .where(daily_navs: { mutual_fund_id: fund.id })
          .maximum("daily_navs.nav_date")

   

      start_date = INITIAL_IMPORT_DATE

      navs =
        fund
          .daily_navs
          .where("nav_date >= ?", start_date)
          .order(:nav_date)
          .to_a

      return false if navs.empty?
        puts "Processing #{fund.isin}"
      build_metrics(fund, navs)

      true
    end

    #######################################################

    def build_metrics(fund, navs)
      timestamp = Time.current

      rows = []

      navs.each_index do |index|
        window = navs.first(index + 1)

        returns =
          Analytics::ReturnsCalculator
            .new(window)
            .calculate

        averages =
          Analytics::MovingAverageCalculator
            .new(window)
            .calculate

        volatility =
          Analytics::VolatilityCalculator
            .new(window)
            .calculate

        drawdown =
          Analytics::DrawdownCalculator
            .new(window)
            .calculate
        if index == 40
          pp returns
          pp averages
          pp volatility
          pp drawdown
        end
        rows << {
          daily_nav_id: navs[index].id,
          mutual_fund_id: fund.id,

          daily_return: returns[:daily],
          weekly_return: returns[:weekly],
          monthly_return: returns[:monthly],
          ytd_return: returns[:ytd],

          moving_average_7: averages[:ma7],
          moving_average_30: averages[:ma30],

          volatility_30: volatility,
          drawdown: drawdown,

          created_at: timestamp,
          updated_at: timestamp
        }
      end
      DailyNavMetric.where(mutual_fund: fund).delete_all
      DailyNavMetric.upsert_all(
        rows,
        unique_by: :daily_nav_id
      )
      puts "Processing #{scope.size} funds..."
      Rails.logger.info(
        "[CalculateDailyMetricsService] #{fund.isin}: #{rows.size} metrics calculated"
      )
    end
  end
end