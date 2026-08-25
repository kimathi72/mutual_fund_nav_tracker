
// api/funds.ts

import api from "./client";

import type { FundSummary } from "@/models/FundSummary";
import type { FundDetails } from "@/models/FundDetails";

interface ApiResponse<T> {
  success: boolean;
  generated_at: string;
  api_version: string;
  data: T;
}

export async function fetchFunds(): Promise<FundSummary[]> {
  const { data } =
    await api.get<ApiResponse<FundSummary[]>>(
      "/funds",
    );

  return data.data;
}

export async function fetchFund(
  id: number,
): Promise<FundDetails> {
  console.log("Loading fund", id);

  const response =
    await api.get<ApiResponse<FundDetails>>(
      `/funds/${id}`,
    );

  console.log("HTTP STATUS");
  console.log(response.status);

  console.log(
    "RAW RESPONSE",
    JSON.stringify(response.data, null, 2),
  );

  return response.data.data;
}
