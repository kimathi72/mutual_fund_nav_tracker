# frozen_string_literal: true

module Ml
  class BuildTrainingDatasetService < ApplicationService
    LOOKBACK_OBSERVATIONS = 35
    INITIAL_IMPORT_DATE = Date.new(2025, 1, 1)

    TARGET_HORIZONS = {
      target_nav_1d: 1,
      target_nav_30d: 30,
      target_nav_90d: 90
    }.freeze

    def initialize(
      scope: MutualFund.where(active: true)
    )
      @scope = scope
    end

    def call
      Rails.logger.info(
        "[BuildTrainingDatasetService] " \
        "Processing #{scope.size} funds..."
      )

      each_fund do |fund|
        build_for_fund(fund)
      rescue StandardError => e
        Rails.logger.error(
          "[BuildTrainingDatasetService] " \
          "#{fund.isin}: #{e.class}: #{e.message}\n" \
          "#{e.backtrace&.first(5)&.join("\n")}"
        )
      end

      Rails.logger.info(
        "[BuildTrainingDatasetService] Finished."
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

    def build_for_fund(fund)
      latest_nav_date =
        DailyNav
          .where(mutual_fund_id: fund.id)
          .maximum(:nav_date)

      unless latest_nav_date
        Rails.logger.info(
          "[BuildTrainingDatasetService] " \
          "#{fund.isin}: no NAV data"
        )

        return false
      end

      last_feature_date =
        MlTrainingRow
          .where(mutual_fund_id: fund.id)
          .maximum(:feature_date)

      if last_feature_date.present? &&
         last_feature_date >= latest_nav_date

        Rails.logger.info(
          "[BuildTrainingDatasetService] " \
          "#{fund.isin}: already up-to-date " \
          "(#{last_feature_date})"
        )

        return false
      end

      start_date =
        if last_feature_date.present?
          previous_observation_window_start(
            fund,
            last_feature_date
          )
        else
          INITIAL_IMPORT_DATE
        end

      navs =
        DailyNav
          .where(mutual_fund_id: fund.id)
          .where("nav_date >= ?", start_date)
          .order(:nav_date)
          .to_a

      if navs.empty?
        Rails.logger.info(
          "[BuildTrainingDatasetService] " \
          "#{fund.isin}: no NAVs from #{start_date}"
        )

        return false
      end

      build_rows(
        fund,
        navs
      )

      true
    end

    def previous_observation_window_start(
      fund,
      feature_date
    )
      previous_dates =
        DailyNav
          .where(mutual_fund_id: fund.id)
          .where("nav_date < ?", feature_date)
          .order(nav_date: :desc)
          .limit(LOOKBACK_OBSERVATIONS)
          .pluck(:nav_date)

      previous_dates.min || feature_date
    end

    def build_rows(fund, navs)
      metrics_by_nav_id =
        DailyNavMetric
          .where(daily_nav_id: navs.map(&:id))
          .index_by(&:daily_nav_id)

      timestamp = Time.current

      rows =
        navs.each_with_index.filter_map do |daily_nav, index|
          metric =
            metrics_by_nav_id[daily_nav.id]

          unless metric
            Rails.logger.warn(
              "[BuildTrainingDatasetService] " \
              "#{fund.isin}: missing metric for " \
              "#{daily_nav.nav_date}"
            )

            next
          end

          {
            mutual_fund_id: fund.id,

            daily_nav_id: daily_nav.id,

            feature_date: daily_nav.nav_date,

            nav: daily_nav.nav,

            return_1d: metric.return_1d,

            return_7d: metric.return_7d,

            return_30d: metric.return_30d,

            ma_7: metric.ma_7,

            ma_30: metric.ma_30,

            ma_90: metric.ma_90,

            volatility_30: metric.volatility_30,

            momentum: metric.momentum,

            target_nav_1d:
              target_nav(
                navs,
                index,
                TARGET_HORIZONS[:target_nav_1d]
              ),

            target_nav_30d:
              target_nav(
                navs,
                index,
                TARGET_HORIZONS[:target_nav_30d]
              ),

            target_nav_90d:
              target_nav(
                navs,
                index,
                TARGET_HORIZONS[:target_nav_90d]
              ),

            created_at: timestamp,

            updated_at: timestamp
          }
        end

      if rows.empty?
        Rails.logger.info(
          "[BuildTrainingDatasetService] " \
          "#{fund.isin}: no training rows generated"
        )

        return
      end

      MlTrainingRow.upsert_all(
        rows,
        unique_by: :idx_ml_training_rows_unique
      )

      Rails.logger.info(
        "[BuildTrainingDatasetService] " \
        "#{fund.isin}: #{rows.size} training rows generated"
      )
    end

    def target_nav(navs, index, observations)
      navs[index + observations]&.nav
    end
  end
end