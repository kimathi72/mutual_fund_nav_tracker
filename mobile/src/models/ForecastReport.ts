export interface ForecastReport {
  fund_id: number;

  isin: string;

  fund_name: string;

  latest_nav: string;

  latest_nav_date: string;

  forecast_date: string;

  target_date: string;

  model_version: string;

  predicted_nav: string;

  expected_change_pct: number;

  confidence: number;

  trend: string;
}