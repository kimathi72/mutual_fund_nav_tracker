import { TimeSeriesPoint } from "@/components/charts/types";

export interface FundPerformance {
  fund_id: number;
  isin: string;
  fund_name: string;

  latest_nav: number;
  nav_date: string;
  currency: string;

  daily_return: number;
  weekly_return: number;
  monthly_return: number;
  ytd_return: number;

  moving_average_7: number;
  moving_average_30: number;
}

export interface FundRisk {
  volatility_30: number;
  drawdown: number;
  risk_level: string;
}

export interface FundForecast {
  predicted_nav: number;
  expected_change_pct: number;

  trend: string;

  confidence: number | null;

  target_date: string;
}

export interface ExecutiveInsight {
  executive_summary: string;

  recommendation: string;

  opportunity_score: number;

  market_outlook: string;

  risk_level: string;

  confidence: string;
}

export interface ForecastPoint extends TimeSeriesPoint {
  confidence?: number;
}

export default interface FundDetails {
  performance: FundPerformance;

  risk: FundRisk;

  forecast: FundForecast;

  executive_insight: ExecutiveInsight;

  nav_history: TimeSeriesPoint[];

  volatility_history: TimeSeriesPoint[];

  forecast_series: ForecastPoint[];
}