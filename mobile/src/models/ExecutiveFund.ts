import { ExecutiveInsight } from "./ExecutiveInsight";
import { ForecastReport } from "./ForecastReport";
import { PerformanceReport } from "./PerformanceReport";
import { RiskReport } from "./RiskReport";

interface ExecutiveFund {
  performance: PerformanceReport;

  risk: RiskReport;

  forecast: ForecastReport;

  executive_insight: ExecutiveInsight;
}
export default ExecutiveFund;