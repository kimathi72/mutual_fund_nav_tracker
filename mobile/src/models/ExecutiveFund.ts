import { PerformanceReport } from "./PerformanceReport";
import { RiskReport } from "./RiskReport";
import { ForecastReport } from "./Forecast";
import { ExecutiveInsight } from "./ExecutiveInsight";
import { TimeSeriesPoint } from "@/components/charts/types";

export interface ForecastPoint extends TimeSeriesPoint {
  confidence?: number;
}

export interface ExecutiveFund {
  performance: PerformanceReport;

  risk: RiskReport;

  forecast: ForecastReport;

  executive_insight: ExecutiveInsight;

  nav_history: TimeSeriesPoint[];

  volatility_history: TimeSeriesPoint[];

  forecast_series: ForecastPoint[];
}