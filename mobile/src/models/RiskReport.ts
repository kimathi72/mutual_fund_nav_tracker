export interface RiskReport {
  fund_id: number;

  isin: string;

  fund_name: string;

  nav_date: string;

  volatility_30: string;

  drawdown: string;

  risk_level: string;
}