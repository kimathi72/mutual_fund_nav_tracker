import api from "./client";

import { PortfolioSummary } from "@/models/PortfolioSummary";
import { PortfolioInsight } from "@/models/PortfolioInsight";

export interface PortfolioResponse {
  summary: PortfolioSummary;
  insight: PortfolioInsight;
}

export async function fetchPortfolio(): Promise<PortfolioResponse> {
  const { data } = await api.get<PortfolioResponse>(
    "/reports/portfolio"
  );

  return data;
}