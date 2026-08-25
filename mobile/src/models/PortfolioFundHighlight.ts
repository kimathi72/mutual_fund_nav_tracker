export interface PortfolioFundHighlight {
  fund_id: number;
  fund_name: string;
  isin: string;

  nav: number | string;

  ytd_return: number | string;

  volatility: number | string;

  drawdown: number | string;
}
