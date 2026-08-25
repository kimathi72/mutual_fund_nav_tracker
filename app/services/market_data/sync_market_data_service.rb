# frozen_string_literal: true
module MarketData
  class SyncMarketDataService < ApplicationService
    def initialize(
      scope: MutualFund.where(active: true),
      lookup_service: Eodhd::SymbolLookup.new
    )
      @scope = scope
      @lookup_service = lookup_service
    end

    def call
      Rails.logger.info(
        "[SyncMarketDataService] Syncing #{@scope.count} mutual funds..."
      )

      @scope.find_each do |fund|
        sync_fund(fund)
      rescue => e
        Rails.logger.error(
          "[SyncMarketDataService] #{fund.isin} failed: #{e.message}"
        )
      end

      Rails.logger.info("[SyncMarketDataService] Finished.")
    end

    private

    attr_reader :scope, :lookup_service

    def sync_fund(fund)
      result = lookup_service.call(fund)

      unless result.found?
        Rails.logger.warn(
          "[SyncMarketDataService] No market data found for #{fund.isin}"
        )
        return
      end

      instrument = result.instrument

      fund.update!(
        market_data_symbol: instrument.symbol,
        market_data_provider: instrument.provider.to_s,
        exchange_code: instrument.exchange,
        security_type: instrument.security_type
      )

      Rails.logger.info(
        "[SyncMarketDataService] #{fund.isin} -> #{instrument.symbol} (#{result.strategy})"
      )
    end
  end
end
# class SyncMarketDataService 
#   def initialize(
#     scope: MutualFund.where(active: true),
#     lookup_service: Eodhd::SymbolLookup.new
#   )
#     @scope = scope
#     @lookup_service = lookup_service
#   end

#   def call
#     Rails.logger.info(
#       "[SyncMarketDataService] Syncing #{@scope.count} mutual funds..."
#     )

#     @scope.find_each do |fund|
#       sync_fund(fund)
#     rescue => e
#       Rails.logger.error(
#         "[SyncMarketDataService] #{fund.isin} failed: #{e.message}"
#       )
#     end

#     Rails.logger.info("[SyncMarketDataService] Finished.")
#   end

#   private

#   attr_reader :scope, :lookup_service

#   def sync_fund(fund)
#     result = lookup_service.call(fund)

#     unless result.found?
#       Rails.logger.warn(
#         "[SyncMarketDataService] No market data found for #{fund.isin}"
#       )
#       return
#     end

#     instrument = result.instrument

#     fund.update!(
#       market_data_symbol: instrument.symbol,
#       market_data_provider: instrument.provider.to_s,
#       exchange_code: instrument.exchange,
#       security_type: instrument.security_type
#     )

#     Rails.logger.info(
#       "[SyncMarketDataService] #{fund.isin} -> #{instrument.symbol} (#{result.strategy})"
#     )
#   end
# end