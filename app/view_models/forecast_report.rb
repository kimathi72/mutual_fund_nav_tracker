# frozen_string_literal: true

class ForecastReport
  attr_reader \
    :fund_id,
    :isin,
    :fund_name,
    :latest_nav,
    :latest_nav_date,
    :forecast_date,
    :target_date,
    :model_version,
    :predicted_nav,
    :expected_change_pct,
    :confidence,
    :trend

  def initialize(
    fund_id:,
    isin:,
    fund_name:,
    latest_nav:,
    latest_nav_date:,
    forecast_date:,
    target_date:,
    model_version:,
    predicted_nav:,
    expected_change_pct:,
    confidence:,
    trend:
  )
    @fund_id = fund_id
    @isin = isin
    @fund_name = fund_name
    @latest_nav = latest_nav
    @latest_nav_date = latest_nav_date
    @forecast_date = forecast_date
    @target_date = target_date
    @model_version = model_version
    @predicted_nav = predicted_nav
    @expected_change_pct = expected_change_pct
    @confidence = confidence
    @trend = trend

    freeze
  end

  def available?
    predicted_nav.present?
  end

  def bullish?
    trend == "Bullish"
  end

  def bearish?
    trend == "Bearish"
  end

  def neutral?
    trend == "Neutral"
  end
end