import api from "./client";

import type {FundSummary} from "@/models/FundSummary";
import type {ExecutiveFund} from "@/models/ExecutiveFund";

interface ApiResponse<T> {
  success: boolean;
  generated_at: string;
  api_version: string;
  data: T;
}

export async function fetchFunds(): Promise<FundSummary[]> {
  const { data } =
    await api.get<ApiResponse<FundSummary[]>>(
      "/funds"
    );

  return data.data;
}

export async function fetchFund(
  id: number
): Promise<ExecutiveFund> {
  console.log("Loading fund", id);

  const response = await api.get(`/funds/${id}`);

  console.log("HTTP STATUS");
  console.log(response.status);

  console.log("RAW RESPONSE");
  console.log(JSON.stringify(response.data, null, 2));

  return response.data.data;
}