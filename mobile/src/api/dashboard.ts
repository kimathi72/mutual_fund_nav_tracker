import apiClient from "./client";

import type { DashboardResponse } from "../models/Dashboard";
import type { FundSummary } from "../models/FundSummary";
import type { FundRanking } from "../models/FundRanking";

const getRankingFunds = (
  rankings: DashboardResponse["rankings"],
): FundRanking[] => {
  return [
    ...rankings.top_ytd,
    ...rankings.top_monthly,
    ...rankings.top_weekly,
    ...rankings.top_daily,
    ...rankings.lowest_risk,
    ...rankings.highest_risk,
    ...rankings.worst_drawdown,
  ];
};

const createRankingLookup = (
  rankings: DashboardResponse["rankings"],
): Map<string, FundRanking> => {
  const lookup = new Map<string, FundRanking>();

  for (const ranking of getRankingFunds(rankings)) {
    if (!lookup.has(ranking.isin)) {
      lookup.set(ranking.isin, ranking);
    }
  }

  return lookup;
};

const normalizeFunds = (
  funds: DashboardResponse["funds"],
  rankings: DashboardResponse["rankings"],
): FundSummary[] => {
  const rankingLookup = createRankingLookup(rankings);

  return funds.map((fund) => {
    const ranking = rankingLookup.get(fund.isin);

    return {
      id: fund.id,
      name: fund.name,
      isin: fund.isin,
      nav: String(fund.nav),

      currency: ranking?.currency ?? "",
      daily_return: String(ranking?.daily_return ?? ""),
      weekly_return: String(ranking?.weekly_return ?? ""),
      monthly_return: String(ranking?.monthly_return ?? ""),

      ytd_return: String(fund.ytd_return),
      volatility: Number(fund.volatility),
      drawdown: String(fund.drawdown),

      recommendation: fund.recommendation,
      market_outlook: fund.market_outlook,
      opportunity_score: Number(fund.opportunity_score),
    };
  });
};

export const getDashboard = async (): Promise<DashboardResponse> => {
  const response = await apiClient.get("/dashboard");

  // Axios response.data = entire API response body.
  // Your actual dashboard payload is inside response.data.data.
  const dashboard = response.data.data;

  return {
    ...dashboard,
    funds: normalizeFunds(
      dashboard.funds,
      dashboard.rankings,
    ),
  };
};