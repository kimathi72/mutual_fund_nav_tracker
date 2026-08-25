// models/FundDetails.ts

import type { ExecutiveFund } from "@/models/ExecutiveFund";
import type { ExecutiveFundHistory } from "@/models/ExecutiveFundHistory";
import type { RiskReport } from "@/models/RiskReport";
import type { ForecastReport } from "@/models/Forecast";

export interface FundDetails
  extends ExecutiveFund {
  risk: RiskReport;
  forecast: ForecastReport;
  history: ExecutiveFundHistory;
}