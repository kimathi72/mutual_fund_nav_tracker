import { PerformanceReport } from "./PerformanceReport";
import { RiskReport } from "./RiskReport";
import {ForecastReport} from "./Forecast";
import { ExecutiveInsight } from "./ExecutiveInsight";

import {ExecutiveFundHistory} from "./ExecutiveFundHistory";

export  interface ExecutiveFund {
  performance: PerformanceReport;

  risk: RiskReport;

  forecast: ForecastReport;

  executive_insight: ExecutiveInsight;

  history: ExecutiveFundHistory;
}