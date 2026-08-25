# frozen_string_literal: true

class PortfolioScore
  RETURN_WEIGHT         = 0.40
  VOLATILITY_WEIGHT     = 0.20
  DRAWDOWN_WEIGHT       = 0.20
  FORECAST_WEIGHT       = 0.10
  RECOMMENDATION_WEIGHT = 0.10

  def initialize(fund)
    @fund = fund
  end

  def score
    (
      return_score * RETURN_WEIGHT +
      volatility_score * VOLATILITY_WEIGHT +
      drawdown_score * DRAWDOWN_WEIGHT +
      forecast_score * FORECAST_WEIGHT +
      recommendation_score * RECOMMENDATION_WEIGHT
    ).round(2)
  end

  private

  attr_reader :fund

  ##############################################
  # Return
  ##############################################

  def return_score
    normalize(
      fund.ytd_return,
      -20,
      30
    )
  end

  ##############################################
  # Lower volatility = better
  ##############################################

  def volatility_score
    inverse_normalize(
      fund.volatility,
      5,
      50
    )
  end

  ##############################################
  # Smaller drawdown = better
  ##############################################

  def drawdown_score
    inverse_normalize(
      fund.drawdown.abs,
      0,
      40
    )
  end

  ##############################################

  def forecast_score
    return 50 unless fund.respond_to?(:forecast)

    confidence =
      fund.forecast&.confidence_score

    confidence || 50
  end

  ##############################################

  def recommendation_score
    RecommendationScore
      .new(fund.recommendation)
      .score
  end

  ##############################################

  def normalize(value, min, max)
    return 50 if value.nil?

    scaled =
      ((value - min) / (max - min).to_f) * 100

    clamp(scaled)
  end

  def inverse_normalize(value, min, max)
    return 50 if value.nil?

    scaled =
      100 -
      (((value - min) / (max - min).to_f) * 100)

    clamp(scaled)
  end

  def clamp(value)
    [[value, 0].max, 100].min
  end
end