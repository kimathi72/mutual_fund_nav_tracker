# frozen_string_literal: true

require "csv"
require "fileutils"

module Ml
  class DatasetExportService < ApplicationService
    DEFAULT_PATH =
      Rails.root
           .join("exports")
           .join("mutual_funds_training_dataset.csv")

    FEATURE_COLUMNS = %w[
      isin
      feature_date
      nav
      return_1d
      return_7d
      return_30d
      ma_7
      ma_30
      ma_90
      volatility_30
      momentum
      target_nav_1d
      target_nav_30d
      target_nav_90d
    ].freeze

    def initialize(path: DEFAULT_PATH)
      @path = Pathname.new(path)
    end

    def call
      FileUtils.mkdir_p(path.dirname)

      rows = build_rows

      CSV.open(path, "wb") do |csv|
        csv << headers

        rows.each do |row|
          csv << row
        end
      end

      Rails.logger.info(
        "[DatasetExportService] " \
        "Exported #{rows.size} training rows to #{path}"
      )

      path
    end

    private

    attr_reader :path

    def build_rows
      dataset.find_each(batch_size: 1_000).map do |record|
        serialize(record)
      end
    end

    def dataset
      MlTrainingRow
        .joins(:mutual_fund)
        .includes(:mutual_fund)
        .order(
          "mutual_funds.isin",
          :feature_date
        )
    end

    def headers
      FEATURE_COLUMNS
    end

    def serialize(record)
      [
        record.mutual_fund.isin,

        record.feature_date,

        record.nav,

        record.return_1d,

        record.return_7d,

        record.return_30d,

        record.ma_7,

        record.ma_30,

        record.ma_90,

        record.volatility_30,

        record.momentum,

        record.target_nav_1d,

        record.target_nav_30d,

        record.target_nav_90d
      ]
    end
  end
end