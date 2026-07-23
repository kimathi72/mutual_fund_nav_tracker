export interface PerformanceReport {
  fund_id: number;

  isin: string;

  fund_name: string;

  nav_date: string;

  latest_nav: number;

  currency: string;

  daily_return: number;

  weekly_return: number;

  monthly_return: number;

  ytd_return: number;

  moving_average_7: number;

  moving_average_30: number;
}