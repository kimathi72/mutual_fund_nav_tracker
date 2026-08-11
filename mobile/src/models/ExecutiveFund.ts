
// models/ExecutiveFund.ts

import type { PerformanceReport } from "@/models/PerformanceReport";
import type { RiskReport } from "@/models/RiskReport";
import type { ForecastReport } from "@/models/Forecast";
import type { NavPoint } from "@/models/NavPoint";
import type { VolatilityPoint } from "@/models/VolatilityPoint";
import type { PredictionPoint } from "@/models/PredictionPoint";

export interface ExecutiveFund {
  id: number;

  name: string;
  isin: string;
  currency: string;

  nav: number | string;
  ytd_return: number | string;
  volatility: number | string;
  drawdown: number | string;

  recommendation: string;
  market_outlook: string;
  opportunity_score: number;
  executive_insight?: ExecutiveInsight;
  performance: PerformanceReport;

  risk: RiskReport;

  forecast: ForecastReport;

  history: FundHistory;

  insight?: ExecutiveInsight;
}

export interface FundHistory {
  nav: NavPoint[];
  volatility: VolatilityPoint[];
  prediction_history: PredictionPoint[];
}

export interface ExecutiveInsight {
  executive_summary: string;
  recommendation: string;
  opportunity_score: number;
  market_outlook: string;
  risk_level: string;
  confidence: string;
  generated_at: string;
}
