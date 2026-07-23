import { useQuery } from "@tanstack/react-query";

import { fetchFund } from "@/api/fund";
import type FundDetails from "@/models/FundDetails";

export function useFundDetails(id: number) {
  return useQuery<FundDetails>({
    queryKey: ["fund", id],

    queryFn: () => fetchFund(id),

    enabled: !!id,

    staleTime: 5 * 60 * 1000,
    gcTime: 15 * 60 * 1000,

    refetchOnWindowFocus: false,
    retry: 2,
  });
}