// models/Forecast.ts

export type ForecastHorizon = "1d" | "30d" | "90d";

export interface Forecast {
  /**
   * Rails Forecast primary key.
   *
   * This is the canonical identity for a forecast.
   */
  forecast_id: number;

  /**
   * Fund identifier.
   */
  isin: string;

  /**
   * Forecast horizon.
   */
  horizon: ForecastHorizon;

  /**
   * When the forecast was generated.
   */
  predicted_at: string | null;

  /**
   * Date the prediction targets.
   */
  target_date: string | null;

  /**
   * Predicted NAV.
   */
  predicted_nav: number | null;

  /**
   * Lower prediction bound.
   */
  lower_bound: number | null;

  /**
   * Upper prediction bound.
   */
  upper_bound: number | null;

  /**
   * Model confidence.
   *
   * Rails/Python may expose this either as:
   *   0.75
   * or
   *   75
   *
   * The UI normalizes it before displaying.
   */
  confidence_score: number | null;

  /**
   * Expected percentage return from origin NAV.
   */
  expected_return_pct: number | null;

  /**
   * NAV at forecast origin.
   */
  origin_nav: number | null;

  /**
   * Direction/trend information.
   */
  trend: string | null;

  /**
   * Model recommendation.
   */
  recommendation: string | null;

  /**
   * Model identifier/version.
   */
  model_version: string | null;

  /**
   * Actual NAV once the forecast has been evaluated.
   */
  actual_nav: number | null;

  /**
   * Absolute forecast error.
   */
  absolute_error: number | null;

  /**
   * Percentage forecast error.
   */
  percentage_error: number | null;

  /**
   * Whether predicted direction matched actual direction.
   *
   * null = not scored yet.
   */
  direction_correct: boolean | null;

  /**
   * When scoring was completed.
   */
  scored_at: string | null;
}

export interface ForecastReport {
  predictions: Forecast[];
}