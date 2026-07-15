export interface FundSummary {
  fund_id: number;
  fund_name: string;
  isin: string;

  nav: string;

  ytd_return: string;

  volatility: string;

  drawdown: string;
}

export interface PortfolioSummary {
  report_date: string;

  total_funds: number;

  average_daily_return: string;

  average_weekly_return: string;

  average_monthly_return: string;

  average_ytd_return: string;

  average_volatility: string;

  best_performer: FundSummary;

  worst_performer: FundSummary;

  highest_risk: FundSummary;

  lowest_risk: FundSummary;
}