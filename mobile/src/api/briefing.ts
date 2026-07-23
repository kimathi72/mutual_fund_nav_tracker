import api from "./client";

import { ExecutiveBriefing } from "@/models/ExecutiveBriefing";

export async function fetchBriefing(): Promise<ExecutiveBriefing> {
  const { data } =
    await api.get<ExecutiveBriefing>(
      "/briefing"
    );

  return data;
}