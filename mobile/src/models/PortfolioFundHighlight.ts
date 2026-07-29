export interface PortfolioFundHighlight {
  fund_id: number;
  fund_name: string;
  isin: string;

  nav: string;

  ytd_return: string;

  volatility: number;

  drawdown: string;
}