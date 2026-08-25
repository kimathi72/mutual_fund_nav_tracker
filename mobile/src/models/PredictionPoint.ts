// models/PredictionPoint.ts

export type PredictionHorizon =
  | "1d"
  | "30d"
  | "90d";

export interface PredictionPoint {
  /**
   * When this prediction was generated.
   *
   * Used to determine which duplicate
   * prediction is the newest.
   */
  generated_at: string;

  /**
   * Forecast target date.
   */
  target_date: string;

  /**
   * Prediction horizon.
   */
  horizon: PredictionHorizon;

  /**
   * Predicted NAV.
   */
  predicted_nav: number | string;

  /**
   * Lower prediction bound.
   */
  lower_bound: number | string | null;

  /**
   * Upper prediction bound.
   */
  upper_bound: number | string | null;

  /**
   * Model confidence.
   */
  confidence: number | string | null;
}