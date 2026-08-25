import { useQuery } from "@tanstack/react-query";

import { fetchRankings } from "@/api/rankings";

import { RankingReport } from "@/models/RankingReport";

export function useRankings() {
  return useQuery<RankingReport>({
    queryKey: ["rankings"],

    queryFn: fetchRankings,

    staleTime: 5 * 60 * 1000,

    gcTime: 30 * 60 * 1000,

    refetchOnWindowFocus: false,
  });
}