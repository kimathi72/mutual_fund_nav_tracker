export interface FundIdentity {
  id: number;
  isin: string;
  name: string;
}

export interface LatestNav {
  value: number | null;
  date: string | null;
}

export interface Forecast {
  horizon: "1d" | "30d" | "90d";

  predicted_at: string | null;
  target_date: string | null;

  predicted_nav: number | null;

  lower_bound: number | null;
  upper_bound: number | null;

  confidence_score: number | null;
  expected_return_pct: number | null;

  model_version: string | null;

  trend: string;
  recommendation: string;
}

export interface ForecastReport {
  fund: FundIdentity;

  latest_nav: LatestNav;

  forecasts: Forecast[];
}