# app/serializers/fund_serializer.rb

# frozen_string_literal: true

class FundSerializer
  def initialize(fund)
    @fund = fund
  end

  def as_json(*)
    nav = @fund.latest_daily_nav
    metrics = @fund.latest_metrics
    forecast = @fund.forecasts.order(target_date: :desc).first

    {
      id: @fund.id,
      isin: @fund.isin,
      name: @fund.name,

      currency: @fund.currency,
      active: @fund.active,

      market_data: {
        symbol: @fund.market_data_symbol,
        exchange: @fund.exchange_code
      },

      nav: nav&.nav,
      nav_date: nav&.nav_date,

      performance: {
        daily: metrics&.daily_return,
        weekly: metrics&.weekly_return,
        monthly: metrics&.monthly_return,
        ytd: metrics&.ytd_return
      },

      moving_averages: {
        ma7: metrics&.moving_average_7,
        ma30: metrics&.moving_average_30
      },

      risk: {
        volatility: metrics&.volatility_30,
        drawdown: metrics&.drawdown
      },

      forecast:
        if forecast
          {
            target_date: forecast.target_date,
            predicted_nav: forecast.predicted_nav,
            confidence: forecast.confidence_score
          }
        else
          nil
        end
    }
  end
end