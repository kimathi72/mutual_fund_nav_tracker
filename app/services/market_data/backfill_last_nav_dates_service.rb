# frozen_string_literal: true

module MarketData
  class BackfillLastNavDatesService < ApplicationService
    def call
      MutualFund.find_each do |fund|
        last_date = DailyNav
                      .where(mutual_fund_id: fund.id)
                      .maximum(:nav_date)

        next unless last_date

        fund.update_columns(
          last_nav_date: last_date,
          last_market_data_sync_at: Time.current
        )

        Rails.logger.info(
          "[BackfillLastNavDatesService] #{fund.isin} -> #{last_date}"
        )
      end

      true
    end
  end
end