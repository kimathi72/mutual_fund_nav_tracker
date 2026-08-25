
import type { PortfolioFundHighlight } from './PortfolioFundHighlight';

export interface PortfolioSummary {
  report_date: string;

  total_funds: number;

  average_daily_return: number | string;
  average_weekly_return: number | string;
  average_monthly_return: number | string;
  average_ytd_return: number | string;

  average_volatility: number | string;

  buy_count: number;
  hold_count: number;
  sell_count: number;

  bullish_count: number;
  bearish_count: number;

  average_opportunity_score: number | string;

  best_performer: PortfolioFundHighlight;
  worst_performer: PortfolioFundHighlight;
  highest_risk: PortfolioFundHighlight;
  lowest_risk: PortfolioFundHighlight;
}