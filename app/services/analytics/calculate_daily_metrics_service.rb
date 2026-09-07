
# frozen_string_literal: true

module Analytics
  class CalculateDailyMetricsService < ApplicationService
    INITIAL_IMPORT_DATE = Date.new(2025, 1, 1)

    def initialize(scope: MutualFund.where(active: true))
      @scope = scope
    end

    def call
      Rails.logger.info(
        "[CalculateDailyMetricsService] Processing #{scope.size} funds..."
      )

      failures = []

      each_fund do |fund|
        begin
          calculate_for_fund(fund)
        rescue StandardError => e
          failures << [fund, e]

          Rails.logger.error(
            "[CalculateDailyMetricsService] #{fund.isin}: " \
            "#{e.class}: #{e.message}"
          )

          Rails.logger.error(
            e.backtrace.first(10).join("\n")
          )
        end
      end

      if failures.any?
        summary =
          failures.map do |fund, error|
            "#{fund.isin}: #{error.class}: #{error.message}"
          end.join("; ")

        raise StandardError,
              "[CalculateDailyMetricsService] Failed funds: #{summary}"
      end

      Rails.logger.info(
        "[CalculateDailyMetricsService] Finished successfully."
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

    # ---------------------------------------------------------
    # Fund
    # ---------------------------------------------------------

    def calculate_for_fund(fund)
      latest_nav_date = fund.daily_navs.maximum(:nav_date)

      unless latest_nav_date
        Rails.logger.warn(
          "[CalculateDailyMetricsService] #{fund.isin}: " \
          "no NAV records found"
        )

        return false
      end

      navs =
        fund
          .daily_navs
          .where("nav_date >= ?", INITIAL_IMPORT_DATE)
          .order(:nav_date)
          .to_a

      if navs.empty?
        Rails.logger.warn(
          "[CalculateDailyMetricsService] #{fund.isin}: " \
          "no NAVs found from #{INITIAL_IMPORT_DATE}"
        )

        return false
      end

      Rails.logger.info(
        "[CalculateDailyMetricsService] #{fund.isin}: " \
        "building metrics for #{navs.size} NAV records " \
        "(latest NAV: #{latest_nav_date})"
      )

      build_metrics(fund, navs)

      true
    end

    # ---------------------------------------------------------
    # Metrics
    # ---------------------------------------------------------

    def build_metrics(fund, navs)
      timestamp = Time.current

      rows =
        navs.each_with_index.map do |nav, index|
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

          build_metric_row(
            fund: fund,
            nav: nav,
            returns: returns,
            averages: averages,
            volatility: volatility,
            timestamp: timestamp
          )
        end

      persist_metrics(fund, rows)

      Rails.logger.info(
        "[CalculateDailyMetricsService] #{fund.isin}: " \
        "#{rows.size} metrics persisted"
      )

      true
    end

    # ---------------------------------------------------------
    # Row construction
    # ---------------------------------------------------------

    def build_metric_row(
      fund:,
      nav:,
      returns:,
      averages:,
      volatility:,
      timestamp:
    )
      {
        daily_nav_id: nav.id,
        mutual_fund_id: fund.id,

        # Existing return metrics
        return_1d: returns[:daily],
        return_7d: returns[:weekly],
        return_30d: returns[:monthly],

        # Return from the fixed reporting baseline:
        # 30 June 2026
        return_since_30_june_2026: returns[:since_30_june_2026],

        # Existing volatility metric
        volatility_30: volatility,

        # Existing moving averages
        ma_7: averages[:ma7],
        ma_30: averages[:ma30],

        created_at: timestamp,
        updated_at: timestamp
      }
    end

    # ---------------------------------------------------------
    # Persistence
    # ---------------------------------------------------------

    def persist_metrics(fund, rows)
      return if rows.empty?

      DailyNavMetric.transaction(requires_new: true) do
        # Metrics are rebuilt from the complete NAV history for the fund.
        #
        # The delete and upsert happen inside the same transaction.
        # If upsert_all fails, the transaction rolls back and the
        # previous metrics remain intact.
        DailyNavMetric
          .where(mutual_fund_id: fund.id)
          .delete_all

        DailyNavMetric.upsert_all(
          rows,
          unique_by: :daily_nav_id,
          record_timestamps: false
        )
      end
    end
  end
end