import api from "./client";

import { Dashboard } from "@/models/Dashboard";

interface ApiResponse<T> {
  success: boolean;
  generated_at: string;
  api_version: string;
  data: T;
}

export async function fetchDashboard(): Promise<Dashboard> {
  const { data } = await api.get<ApiResponse<Dashboard>>(
    "/dashboard"
  );

  return data.data;
}