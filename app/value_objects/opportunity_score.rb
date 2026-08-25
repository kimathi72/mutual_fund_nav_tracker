# frozen_string_literal: true

class OpportunityScore
  HIGH_THRESHOLD = 70

  def initialize(score)
    @score = score.to_f
  end

  def high?
    @score >= HIGH_THRESHOLD
  end

  def normal?
    !high?
  end

  def label
    high? ? "High" : "Normal"
  end

  private

  attr_reader :score
end