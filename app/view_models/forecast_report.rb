class ForecastReport
  attr_reader :predictions

  def initialize(predictions:)
    @predictions = predictions
    freeze
  end

  class Prediction
    attr_reader \
      :horizon,
      :predicted_at,
      :target_date,
      :predicted_nav,
      :lower_bound,
      :upper_bound,
      :confidence_score,
      :expected_return_pct,
      :model_version,
      :trend,
      :recommendation

    def initialize(
      horizon:,
      predicted_at:,
      target_date:,
      predicted_nav:,
      lower_bound:,
      upper_bound:,
      confidence_score:,
      expected_return_pct:,
      model_version:,
      trend:,
      recommendation:
    )
      @horizon = horizon
      @predicted_at = predicted_at
      @target_date = target_date
      @predicted_nav = predicted_nav
      @lower_bound = lower_bound
      @upper_bound = upper_bound
      @confidence_score = confidence_score
      @expected_return_pct = expected_return_pct
      @model_version = model_version
      @trend = trend
      @recommendation = recommendation

      freeze
    end
  end
end