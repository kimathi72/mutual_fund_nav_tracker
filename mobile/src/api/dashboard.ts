import api from "./client";

import { Dashboard } from "@/models/Dashboard";

export async function fetchDashboard(): Promise<Dashboard> {
  const { data } = await api.get<Dashboard>(
    "/dashboard"
  );

  return data;
}