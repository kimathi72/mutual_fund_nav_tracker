export interface FundRanking {
  fund_id: number;

  fund_name: string;

  isin: string;

  nav_date: string;

  nav: string;

  currency: string;

  daily_return: number;

  weekly_return: number;

  monthly_return: number;

  ytd_return: number;

  moving_average_7: number;

  moving_average_30: number;

  volatility_30: number;

  drawdown: number;
}