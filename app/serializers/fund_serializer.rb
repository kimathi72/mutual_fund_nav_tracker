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
        risk_level: executive_risk_level
      },

      forecast: forecast_payload,

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
          value: item.nav.to_f
        }
      end,

      volatility_history: volatility_history.map do |item|
        {
          date: item.daily_nav.nav_date,
          value: item.volatility_30.to_f
        }
      end,

      forecast_series: forecast_series.map do |item|
        {
          date: item.target_date,
          value: item.predicted_nav.to_f,
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

  # Latest forecast (used for executive summary)
  def forecast
    details[:forecast]
  end

  def nav_history
    details[:nav_history]
  end

  def volatility_history
    details[:volatility_history]
  end

  # Collection of 1d / 30d / 90d forecasts
  def forecast_series
    details[:forecast_series] || []
  end

  ##################################################
  ## Forecast helpers
  ##################################################

  def forecast_payload
    {
      latest: latest_forecast_payload,
      forecasts: forecast_horizons
    }
  end

  def latest_forecast_payload
    return nil unless forecast

    {
      predicted_nav: forecast.predicted_nav,
      expected_return_pct: forecast.expected_return_pct,
      confidence_score: forecast.confidence_score,
      target_date: forecast.target_date,
      predicted_at: forecast.predicted_at,
      horizon: forecast.horizon,
      model_version: forecast.model_version,
      lower_bound: forecast.lower_bound,
      upper_bound: forecast.upper_bound,
      trend: forecast_trend,
      recommendation: recommendation
    }
  end

  def forecast_horizons
    forecast_series
      .sort_by(&:target_date)
      .map
      .with_index do |item, index|

      horizon =
        case index
        when 0 then "1d"
        when 1 then "30d"
        when 2 then "90d"
        else
          item.respond_to?(:horizon) ? item.horizon : "#{index}d"
        end

      {
        horizon: horizon,
        target_date: item.target_date,
        predicted_nav: item.predicted_nav.to_f,
        expected_return_pct: expected_return(item.predicted_nav),
        confidence_score: item.confidence_score,
        trend: trend_for(item.predicted_nav),
        recommendation: recommendation_for(item.predicted_nav)
      }
    end
  end

  def expected_return(predicted_nav)
    return nil unless nav&.nav.present?

    (((predicted_nav.to_f - nav.nav.to_f) / nav.nav.to_f) * 100).round(2)
  end

  def trend_for(predicted_nav)
    pct = expected_return(predicted_nav)
    return "Neutral" if pct.nil?

    if pct > 0
      "Bullish"
    elsif pct < 0
      "Bearish"
    else
      "Neutral"
    end
  end

  def recommendation_for(predicted_nav)
    pct = expected_return(predicted_nav)
    return "Hold" if pct.nil?

    case pct
    when 10..Float::INFINITY
      "Strong Buy"
    when 3...10
      "Buy"
    when -3...3
      "Hold"
    when -10...-3
      "Reduce Exposure"
    else
      "Sell"
    end
  end

  def forecast_trend
    return "Neutral" unless forecast

    value = forecast.expected_return_pct.to_f

    if value > 0
      "Bullish"
    elsif value < 0
      "Bearish"
    else
      "Neutral"
    end
  end

  ##################################################
  ## Executive insight
  ##################################################

  def executive_summary
    return nil unless forecast

    pct = forecast.expected_return_pct.to_f.round(2)

    "#{fund.name} is forecast to #{forecast_trend.downcase} by #{pct}% over the forecast horizon."
  end

  def recommendation
    return "Hold" unless forecast

    pct = forecast.expected_return_pct.to_f

    if pct >= 10
      "Strong Buy"
    elsif pct >= 3
      "Buy"
    elsif pct > -3
      "Hold"
    elsif pct > -10
      "Reduce Exposure"
    else
      "Sell"
    end
  end

  def opportunity_score
    return 0 unless forecast

    forecast.expected_return_pct.to_f.round
  end

  def market_outlook
    forecast_trend
  end

  ##################################################
  ## Risk
  ##################################################

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