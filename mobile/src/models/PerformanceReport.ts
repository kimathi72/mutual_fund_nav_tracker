export interface PerformanceReport {
  fund_id: number;

  isin: string;

  fund_name: string;

  nav_date: string;

  latest_nav: string;

  currency: string;

  daily_return: string;

  weekly_return: string;

  monthly_return: string;

  ytd_return: string;

  moving_average_7: string;

  moving_average_30: string;
}