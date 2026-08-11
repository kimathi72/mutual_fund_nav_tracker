import type { PortfolioSummary } from './PortfolioSummary';
import type { RankingReport } from './RankingReport';
import type { PortfolioInsight } from './PortfolioInsight';
import type { ExecutiveBriefing } from './ExecutiveBriefing';
import type { FundSummary } from './FundSummary';

export interface DashboardResponse {
  summary: PortfolioSummary;
  rankings: RankingReport;
  portfolio_insight: PortfolioInsight;
  briefing: ExecutiveBriefing;
  funds: FundSummary[];
}