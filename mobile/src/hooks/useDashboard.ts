import { useQuery } from "@tanstack/react-query";

import { fetchDashboard } from "@/api/dashboard";

import { Dashboard } from "@/models/Dashboard";

export function useDashboard() {
  return useQuery<Dashboard>({
    queryKey: ["dashboard"],
    queryFn: fetchDashboard,
    staleTime: 60_000,
  });
}