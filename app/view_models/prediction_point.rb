# frozen_string_literal: true

class PredictionPoint
  attr_reader \
    :generated_at,
    :target_date,
    :horizon,
    :predicted_nav,
    :lower_bound,
    :upper_bound,
    :confidence

  def initialize(
    generated_at:,
    target_date:,
    horizon:,
    predicted_nav:,
    lower_bound:,
    upper_bound:,
    confidence:
  )
    @generated_at = generated_at
    @target_date = target_date
    @horizon = horizon
    @predicted_nav = predicted_nav
    @lower_bound = lower_bound
    @upper_bound = upper_bound
    @confidence = confidence

    freeze
  end
end