import api from "./client";

import { RankingReport } from "@/models/RankingReport";

interface ApiResponse<T> {
  success: boolean;
  generated_at: string;
  api_version: string;
  data: T;
}

export async function fetchRankings(): Promise<RankingReport> {
  const { data } =
    await api.get<ApiResponse<RankingReport>>(
      "/rankings"
    );

  return data.data;
}