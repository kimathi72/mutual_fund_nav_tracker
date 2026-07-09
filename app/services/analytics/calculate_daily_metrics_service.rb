# frozen_string_literal: true

module Analytics
  class CalculateDailyMetricsService < ApplicationService
    LOOKBACK_DAYS = 35
    INITIAL_IMPORT_DATE = Date.new(2025, 1, 1)

    def initialize(scope: MutualFund.where(active: true))
      @scope = scope

      @daily_calculator = Analytics::Calculators::DailyReturnCalculator.new
      @weekly_calculator = Analytics::Calculators::WeeklyReturnCalculator.new
      @monthly_calculator = Analytics::Calculators::MonthlyReturnCalculator.new
      @ytd_calculator = Analytics::Calculators::YtdReturnCalculator.new
      @moving_average_calculator = Analytics::Calculators::MovingAverageCalculator.new
      @volatility_calculator = Analytics::Calculators::VolatilityCalculator.new
      @drawdown_calculator = Analytics::Calculators::DrawdownCalculator.new
    end

    def call
      Rails.logger.info(
        "[CalculateDailyMetricsService] Starting..."
      )

      scope.find_each do |fund|
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

    attr_reader :scope,
                :daily_calculator,
                :weekly_calculator,
                :monthly_calculator,
                :ytd_calculator,
                :moving_average_calculator,
                :volatility_calculator,
                :drawdown_calculator

    def calculate_for_fund(fund)
      latest_nav_date =
        DailyNav
          .where(mutual_fund: fund)
          .maximum(:nav_date)

      return unless latest_nav_date

      last_metric_date =
        DailyNavMetric
          .joins(:daily_nav)
          .where(daily_navs: { mutual_fund_id: fund.id })
          .maximum("daily_navs.nav_date")

      if last_metric_date.present? &&
         last_metric_date >= latest_nav_date
        Rails.logger.info(
          "[CalculateDailyMetricsService] #{fund.isin}: already up-to-date"
        )
        return
      end

      start_date =
        if last_metric_date.present?
          rolling_start = last_metric_date - LOOKBACK_DAYS.days
          year_start = Date.new(latest_nav_date.year, 1, 1)

          [rolling_start, year_start].min
        else
          INITIAL_IMPORT_DATE
        end

      navs =
        DailyNav
          .where(mutual_fund: fund)
          .where("nav_date >= ?", start_date)
          .order(:nav_date)
          .to_a

      return if navs.empty?

      build_metrics(fund, navs)
    end

    def build_metrics(fund, navs)
      timestamp = Time.current

      rows =
        navs.each_with_index.map do |nav, index|
          {
            daily_nav_id: nav.id,
            mutual_fund_id: fund.id,

            daily_return:
              daily_calculator.call(navs, index),

            weekly_return:
              weekly_calculator.call(navs, index),

            monthly_return:
              monthly_calculator.call(navs, index),

            ytd_return:
              ytd_calculator.call(navs, index),

            moving_average_7:
              moving_average_calculator.call(
                navs,
                index,
                window: 7
              ),

            moving_average_30:
              moving_average_calculator.call(
                navs,
                index,
                window: 30
              ),

            volatility_30:
              volatility_calculator.call(
                navs,
                index
              ),

            drawdown:
              drawdown_calculator.call(
                navs,
                index
              ),

            created_at: timestamp,
            updated_at: timestamp
          }
        end

      DailyNavMetric.upsert_all(
        rows,
        unique_by: :daily_nav_id
      )

      Rails.logger.info(
        "[CalculateDailyMetricsService] #{fund.isin}: #{rows.size} metrics calculated"
      )
    end
  end
end