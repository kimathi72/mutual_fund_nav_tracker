export interface FundSummary {
  id: number;

  name: string;

  isin: string;

  nav: string;

  currency: string;

  daily_return: string;

  weekly_return: string;

  monthly_return: string;

  ytd_return: string;

  volatility: number;

  drawdown: string;

  recommendation: string;

  market_outlook: string;

  opportunity_score: number;
}