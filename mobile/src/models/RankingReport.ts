import { FundRanking } from "./FundRanking";

export interface RankingReport {
  report_date: string;

  top_ytd: FundRanking[];

  top_monthly: FundRanking[];

  top_weekly: FundRanking[];

  top_daily: FundRanking[];

  lowest_risk: FundRanking[];

  highest_risk: FundRanking[];

  largest_drawdown: FundRanking[];
}