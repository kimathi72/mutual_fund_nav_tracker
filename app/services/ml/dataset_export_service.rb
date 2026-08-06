# app/services/ml/dataset_export_service.rb

# frozen_string_literal: true

require "csv"
require "fileutils"

module Ml
  class DatasetExportService < ApplicationService
    DEFAULT_PATH =
      Rails.root
           .join("exports")
           .join("mutual_funds_dataset.csv")

    FEATURE_COLUMNS = %w[
      isin
      nav_date
      nav
      daily_return
      weekly_return
      monthly_return
      ytd_return
      volatility_30
      drawdown
      moving_average_7
      moving_average_30
      lag_1
      lag_5
      lag_20
      rolling_mean_7
      rolling_mean_30
      rolling_std_7
      rolling_std_30
      calendar_month
      calendar_quarter
      calendar_year
      is_month_end
      is_quarter_end
    ].freeze

    def initialize(path: DEFAULT_PATH)
      @path = Pathname.new(path)
    end

    def call
      FileUtils.mkdir_p(path.dirname)

      rows = build_rows

      CSV.open(path, "wb") do |csv|
        csv << headers
        rows.each { |row| csv << row }
      end

      Rails.logger.info(
        "[DatasetExportService] Exported #{rows.size} NAV records to #{path}"
      )

      path
    end

    private

    attr_reader :path

    def build_rows
      records = dataset.to_a
      rows = []

      records.group_by(&:mutual_fund_id).each_value do |fund_records|
        history = []

        fund_records.sort_by(&:nav_date).each do |record|
          rows << serialize(record, history)
          history << record
        end
      end

      rows.sort_by { |row| [row[0], row[1]] }
    end

    def dataset
      DailyNav
        .joins(:mutual_fund)
        .includes(:mutual_fund, :daily_nav_metric)
        .order(
          "mutual_funds.isin",
          :nav_date
        )
    end

    def headers
      FEATURE_COLUMNS
    end

    def serialize(record, history)
      previous_nav = history.last&.nav
      prev_navs = history.map(&:nav)
      current_nav = record.nav.to_f

      metric = record.daily_nav_metric
      daily_return = metric&.daily_return.presence || pct_change(previous_nav, current_nav)
      weekly_return = metric&.weekly_return.presence
      monthly_return = metric&.monthly_return.presence
      ytd_return = metric&.ytd_return.presence
      volatility_30 = metric&.volatility_30.presence
      drawdown = metric&.drawdown.presence
      moving_average_7 = metric&.moving_average_7.presence
      moving_average_30 = metric&.moving_average_30.presence

      lag_1 = previous_nav
      lag_5 = prev_navs[-5]
      lag_20 = prev_navs[-20]

      rolling_mean_7 = moving_average(prev_navs, 7)
      rolling_mean_30 = moving_average(prev_navs, 30)
      rolling_std_7 = rolling_stddev(prev_navs, 7)
      rolling_std_30 = rolling_stddev(prev_navs, 30)

      [
        record.mutual_fund.isin,
        record.nav_date,
        current_nav,
        daily_return,
        weekly_return,
        monthly_return,
        ytd_return,
        volatility_30,
        drawdown,
        moving_average_7,
        moving_average_30,
        lag_1,
        lag_5,
        lag_20,
        rolling_mean_7,
        rolling_mean_30,
        rolling_std_7,
        rolling_std_30,
        record.nav_date.month,
        quarter(record.nav_date),
        record.nav_date.year,
        record.nav_date.end_of_month == record.nav_date,
        record.nav_date.end_of_quarter == record.nav_date
      ]
    end

    def pct_change(previous_nav, current_nav)
      return nil if previous_nav.blank? || current_nav.blank?
      return nil if previous_nav.to_f.zero?

      ((current_nav - previous_nav.to_f) / previous_nav.to_f).round(8)
    end

    def moving_average(values, window)
      return nil if values.empty?

      subset = values.last(window)
      return nil if subset.size < 2

      (subset.sum / subset.size.to_f).round(8)
    end

    def rolling_stddev(values, window)
      return nil if values.empty?

      subset = values.last(window)
      return nil if subset.size < 2

      mean = subset.sum / subset.size.to_f
      variance = subset.sum { |value| (value - mean) ** 2 } / subset.size.to_f
      Math.sqrt(variance).round(8)
    end

    def quarter(date)
      ((date.month - 1) / 3) + 1
    end
  end
end