export interface FundRanking {
  rank: number;

  id: number;
  name: string;
  isin: string;

  nav: number | string;
  currency: string;

  daily_return: number | string;
  weekly_return: number | string;
  monthly_return: number | string;
  ytd_return: number ;

  volatility: number | string;
  drawdown: number | string;
}
