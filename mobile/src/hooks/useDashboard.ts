import { useQuery } from "@tanstack/react-query";

import { fetchDashboard } from "@/api/dashboard";
import type { Dashboard } from "@/models/Dashboard";

export function useDashboard() {
  return useQuery<Dashboard>({
    queryKey: ["dashboard"],
    queryFn: fetchDashboard,

    staleTime: 60 * 1000,
    gcTime: 5 * 60 * 1000,

    refetchOnWindowFocus: false,
    refetchOnReconnect: true,
    retry: 2,
  });
}