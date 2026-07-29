export interface PredictionPoint {
  generated_at: string;

  target_date: string;

  horizon: string;

  predicted_nav: number;

  lower_bound: number;

  upper_bound: number;

  confidence: number;
}