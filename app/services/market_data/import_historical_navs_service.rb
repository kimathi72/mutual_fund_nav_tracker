# frozen_string_literal: true

module MarketData
  class ImportHistoricalNavsService < ApplicationService
    DEFAULT_FROM = Date.new(2025, 1, 1)

    def initialize(
      scope: MutualFund.where(active: true),
      client: Eodhd::HistoricalNavClient.new,
      from: DEFAULT_FROM,
      to: Date.current
    )
      @scope = scope
      @client = client
      @from = from
      @to = to
    end

    def call
      Rails.logger.info(
        "[ImportHistoricalNavsService] Starting NAV import..."
      )

      imported_funds = []

      scope.find_each do |fund|
        imported = import_fund(fund)

        imported_funds << fund if imported
      rescue => e
        Rails.logger.error(
          "[ImportHistoricalNavsService] #{fund.isin}: #{e.class} #{e.message}"
        )
      end

      Rails.logger.info(
        "[ImportHistoricalNavsService] Finished."
      )

      imported_funds
    end

    private

    attr_reader :scope,
                :client,
                :from,
                :to

    def import_fund(fund)
      unless fund.market_data_symbol.present? &&
             fund.exchange_code.present?

        Rails.logger.warn(
          "[ImportHistoricalNavsService] #{fund.isin}: missing market data mapping"
        )

        return false
      end

      import_from = next_missing_date(fund)

      unless import_from
        Rails.logger.info(
          "[ImportHistoricalNavsService] #{fund.isin}: already up-to-date"
        )

        return false
      end

      Rails.logger.info(
        "[ImportHistoricalNavsService] #{fund.isin}: #{import_from} -> #{to}"
      )

      records = client.fetch(
        symbol: fund.market_data_symbol,
        exchange: fund.exchange_code,
        from: import_from,
        to: to
      )

      if records.empty?
        Rails.logger.warn(
          "[ImportHistoricalNavsService] #{fund.isin}: provider returned no records"
        )

        return false
      end

      timestamp = Time.current

      rows = records.map do |record|
        {
          mutual_fund_id: fund.id,
          nav_date: record[:nav_date],
          nav: record[:nav],
          currency: record[:currency] || fund.currency,
          source: "eodhd",
          fetched_at: timestamp,
          provider_symbol: record[:provider_symbol],
          provider_exchange: record[:provider_exchange],
          raw_payload: record[:raw_payload],
          created_at: timestamp,
          updated_at: timestamp
        }
      end

      DailyNav.upsert_all(
        rows,
        unique_by: %i[mutual_fund_id nav_date]
      )

      latest_date = rows.max_by { |row| row[:nav_date] }[:nav_date]

      fund.update_columns(
        last_nav_date: latest_date,
        last_market_data_sync_at: Time.current
      )

      Rails.logger.info(
        "[ImportHistoricalNavsService] #{fund.isin}: imported #{rows.size} NAV records"
      )

      true
    end

    def next_missing_date(fund)
      return from unless fund.last_nav_date.present?

      next_date = fund.last_nav_date + 1.day

      return nil if next_date >= Date.current

      next_date
    end
  end
end