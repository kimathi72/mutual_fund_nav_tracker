import { PortfolioFundHighlight } from "./PortfolioFundHighlight";

export interface PortfolioSummary {
  report_date: string;

  total_funds: number;

  average_daily_return: string;
  average_weekly_return: string;
  average_monthly_return: string;
  average_ytd_return: string;

  average_volatility: string;

  best_performer: PortfolioFundHighlight;
  worst_performer: PortfolioFundHighlight;
  highest_risk: PortfolioFundHighlight;
  lowest_risk: PortfolioFundHighlight;
}