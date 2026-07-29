import { PortfolioSummary } from "./PortfolioSummary";
import { RankingReport } from "./RankingReport";
import { PortfolioInsight } from "./PortfolioInsight";
import  {FundSummary}  from "./FundSummary";
import { ExecutiveBriefing } from "./ExecutiveBriefing";

export interface Dashboard {
  generated_at: string;

  summary: PortfolioSummary;

  rankings: RankingReport;

  portfolio_insight: PortfolioInsight;

  briefing: ExecutiveBriefing | null;

  funds: FundSummary[];
}