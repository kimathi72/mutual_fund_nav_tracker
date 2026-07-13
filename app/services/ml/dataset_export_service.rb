# app/services/ml/dataset_export_service.rb

# frozen_string_literal: true

require "csv"
require "fileutils"

module Ml
  class DatasetExportService < ApplicationService
    DEFAULT_PATH =
      Rails.root
           .join("exports")
           .join("training_dataset.csv")

    def initialize(path: DEFAULT_PATH)
      @path = Pathname.new(path)
    end

    def call
      FileUtils.mkdir_p(path.dirname)

      total_rows = dataset.count

      CSV.open(path, "wb") do |csv|
        csv << headers

        dataset.find_each(batch_size: 1_000) do |row|
          csv << serialize(row)
        end
      end

      Rails.logger.info(
        "[DatasetExportService] Exported #{total_rows} training rows to #{path}"
      )

      path
    end

    private

    attr_reader :path

    def dataset
      MlTrainingRow
        .where.not(next_day_nav: nil)
        .order(:mutual_fund_id, :feature_date)
    end

    def headers
      %w[
        mutual_fund_id
        feature_date
        nav
        daily_return
        weekly_return
        monthly_return
        ytd_return
        moving_average_7
        moving_average_30
        volatility_30
        drawdown
        next_day_nav
      ]
    end

    def serialize(row)
      [
        row.mutual_fund_id,
        row.feature_date,
        row.nav,
        row.daily_return,
        row.weekly_return,
        row.monthly_return,
        row.ytd_return,
        row.moving_average_7,
        row.moving_average_30,
        row.volatility_30,
        row.drawdown,
        row.next_day_nav
      ]
    end
  end
end