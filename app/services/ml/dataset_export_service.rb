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

    def initialize(path: DEFAULT_PATH)
      @path = Pathname.new(path)
    end

    def call
      FileUtils.mkdir_p(path.dirname)

      total_rows = dataset.count

      CSV.open(path, "wb") do |csv|
        csv << headers

        dataset.find_each(batch_size: 1000) do |row|
          csv << serialize(row)
        end
      end

      Rails.logger.info(
        "[DatasetExportService] Exported #{total_rows} NAV records to #{path}"
      )

      path
    end

    private

    attr_reader :path

    def dataset
      DailyNav
        .joins(:mutual_fund)
        .includes(:mutual_fund)
        .order(
          "mutual_funds.isin",
          :nav_date
        )
    end

    def headers
      %w[
        isin
        nav_date
        nav
      ]
    end

    def serialize(row)
      [
        row.mutual_fund.isin,
        row.nav_date,
        row.nav
      ]
    end
  end
end