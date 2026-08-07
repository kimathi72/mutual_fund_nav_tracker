import api from "./client";

import { ExecutiveBriefing } from "@/models/ExecutiveBriefing";

interface ApiResponse<T> {
  success: boolean;
  generated_at: string;
  api_version: string;
  data: T;
}

export async function fetchBriefing(): Promise<ExecutiveBriefing> {
  const { data } =
    await api.get<ApiResponse<ExecutiveBriefing>>(
      "/reports/briefing"
    );

  return data.data;
}