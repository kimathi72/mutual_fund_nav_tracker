# frozen_string_literal: true

class RecommendationScore
  LEVELS = {
    "Strong Buy" => {
      normalized: "Buy",
      weight: 2,
      score: 100,
      color: "success",
      icon: "arrow-up-bold-circle"
    },

    "Buy" => {
      normalized: "Buy",
      weight: 1,
      score: 75,
      color: "success",
      icon: "arrow-up-circle"
    },

    "Hold" => {
      normalized: "Hold",
      weight: 0,
      score: 50,
      color: "warning",
      icon: "pause-circle"
    },

    "Sell" => {
      normalized: "Sell",
      weight: -1,
      score: 25,
      color: "danger",
      icon: "arrow-down-circle"
    },

    "Strong Sell" => {
      normalized: "Sell",
      weight: -2,
      score: 0,
      color: "danger",
      icon: "arrow-down-bold-circle"
    }
  }.freeze

  DEFAULT = {
    normalized: "Hold",
    weight: 0,
    score: 50,
    color: "warning",
    icon: "pause-circle"
  }.freeze

  def initialize(recommendation)
    @recommendation = recommendation.to_s.strip
  end

  def label
    recommendation.presence || "Hold"
  end

  def normalized
    data[:normalized]
  end

  def weight
    data[:weight]
  end

  def score
    data[:score]
  end

  def color
    data[:color]
  end

  def icon
    data[:icon]
  end

  def buy?
    normalized == "Buy"
  end

  def hold?
    normalized == "Hold"
  end

  def sell?
    normalized == "Sell"
  end

  def strong?
    weight.abs == 2
  end

  def bullish?
    weight.positive?
  end

  def bearish?
    weight.negative?
  end

  private

  attr_reader :recommendation

  def data
    LEVELS.fetch(recommendation, DEFAULT)
  end
end