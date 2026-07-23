import api from "./client";

import { RankingReport } from "@/models/RankingReport";

export async function fetchRankings(): Promise<RankingReport> {
  const { data } =
    await api.get<RankingReport>(
      "/rankings"
    );

  return data;
}