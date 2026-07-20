import { useQuery } from "@tanstack/react-query";

import { fetchFundDetails } from "@/api/fund";

import FundDetails from "@/models/FundDetails";

export default function useFundDetails(id: number) {
  return useQuery<FundDetails>({
    queryKey: ["fund", id],

    queryFn: () => fetchFundDetails(id),

    staleTime: 5 * 60 * 1000,
  });
}