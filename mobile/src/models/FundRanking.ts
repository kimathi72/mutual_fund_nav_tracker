export interface FundRanking {
  fund_id: number;

  fund_name: string;

  isin: string;

  nav_date: string;

  nav: string;

  currency: string;

  daily_return: string;

  weekly_return: string;

  monthly_return: string;

  ytd_return: string;

  moving_average_7: string;

  moving_average_30: string;

  volatility_30: string;

  drawdown: string;
}