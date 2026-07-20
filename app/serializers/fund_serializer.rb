# frozen_string_literal: true

class FundSerializer
  def initialize(details)
    @details = details
  end

  def as_json(*)
    {
      performance: {
        fund_id: fund.id,
        isin: fund.isin,
        fund_name: fund.name,

        latest_nav: nav&.nav,
        nav_date: nav&.nav_date,
        currency: fund.currency,

        daily_return: metrics&.daily_return,
        weekly_return: metrics&.weekly_return,
        monthly_return: metrics&.monthly_return,
        ytd_return: metrics&.ytd_return,

        moving_average_7: metrics&.moving_average_7,
        moving_average_30: metrics&.moving_average_30
      },

      risk: {
        volatility_30: metrics&.volatility_30,
        drawdown: metrics&.drawdown,
        risk_level: metrics&.risk_level
      },

      forecast: forecast && {
        predicted_nav: forecast.predicted_nav,
        expected_change_pct: forecast.expected_change_pct,
        trend: forecast.trend,
        confidence: forecast.confidence_score,
        target_date: forecast.target_date
      },

      executive_insight: {
        executive_summary: executive_summary,
        recommendation: recommendation,
        opportunity_score: opportunity_score,
        market_outlook: market_outlook,
        risk_level: executive_risk_level,
        confidence: executive_confidence,
        generated_at: Time.current
      },

      nav_history: nav_history.map do |item|
        {
          date: item.nav_date,
          value: item.nav
        }
      end,

      volatility_history: volatility_history.map do |item|
        {
          date: item.daily_nav.nav_date,
          value: item.volatility_30
        }
      end,

      forecast_series: forecast_series.map do |item|
        {
          date: item.target_date,
          value: item.predicted_nav,
          confidence: item.confidence_score
        }
      end
    }
  end

  private

  attr_reader :details

  def fund
    details[:fund]
  end

  def nav
    details[:nav]
  end

  def metrics
    details[:metrics]
  end

  def forecast
    details[:forecast]
  end

  def nav_history
    details[:nav_history]
  end

  def volatility_history
    details[:volatility_history]
  end

  def forecast_series
    details[:forecast_series]
  end

  def executive_summary
    return nil unless forecast

    "#{fund.name} is forecast to #{forecast.trend.downcase} by #{forecast.expected_change_pct}%."
  end

  def recommendation
    return "Hold" unless forecast

    forecast.trend == "Bullish" ? "Increase exposure" : "Reduce exposure"
  end

  def opportunity_score
    return 0 unless forecast

    forecast.expected_change_pct.to_f.round
  end

  def market_outlook
    forecast&.trend
  end

  def executive_risk_level
    return "Unknown" unless metrics

    volatility = metrics.volatility_30.to_f

    case volatility
    when 0...0.05
      "Low"
    when 0.05...0.15
      "Medium"
    else
      "High"
    end
  end

  def executive_confidence
    forecast&.confidence_score
  end
end