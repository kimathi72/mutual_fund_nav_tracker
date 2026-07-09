# frozen_string_literal: true

module Ml
  class BuildTrainingDatasetService < ApplicationService
    LOOKBACK_DAYS = 35

    def initialize(scope: MutualFund.active)
      @scope = scope
    end

    def call
      Rails.logger.info(
        "[BuildTrainingDatasetService] Starting..."
      )

      scope.find_each do |fund|
        build_for_fund(fund)
      rescue => e
        Rails.logger.error(
          "[BuildTrainingDatasetService] #{fund.isin}: #{e.class} #{e.message}"
        )
      end

      Rails.logger.info(
        "[BuildTrainingDatasetService] Finished."
      )

      true
    end

    private

    attr_reader :scope

    def build_for_fund(fund)
      last_feature_date =
        MlTrainingRow
          .where(mutual_fund: fund)
          .maximum(:feature_date)

      latest_metric_date =
        DailyNavMetric
          .joins(:daily_nav)
          .where(daily_navs: { mutual_fund_id: fund.id })
          .maximum("daily_navs.nav_date")

      return unless latest_metric_date

      if last_feature_date.present? &&
         last_feature_date >= latest_metric_date
        Rails.logger.info(
          "[BuildTrainingDatasetService] #{fund.isin}: already up-to-date"
        )
        return
      end

      start_date =
        if last_feature_date.present?
          last_feature_date - LOOKBACK_DAYS.days
        else
          Date.new(2025, 1, 1)
        end

      metrics =
        DailyNavMetric
          .includes(:daily_nav)
          .joins(:daily_nav)
          .where(mutual_fund_id: fund.id)
          .where("daily_navs.nav_date >= ?", start_date)
          .order("daily_navs.nav_date ASC")
          .to_a

      return if metrics.empty?

      build_rows(metrics)
    end

    def build_rows(metrics)
      feature_builder = Ml::FeatureRowBuilder.new
      target_builder = Ml::TargetCalculator.new

      timestamp = Time.current

      rows =
        metrics.each_with_index.map do |metric, index|
          feature_builder
            .call(metric)
            .merge(
              next_day_nav: target_builder.call(metrics, index),
              created_at: timestamp,
              updated_at: timestamp
            )
        end

      MlTrainingRow.upsert_all(
        rows,
        unique_by: :idx_ml_training_rows_unique
      )

      Rails.logger.info(
        "[BuildTrainingDatasetService] Imported #{rows.size} feature rows"
      )
    end
  end
end