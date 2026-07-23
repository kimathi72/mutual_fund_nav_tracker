import api from "./client";
import type FundDetails from "@/models/FundDetails";

interface ApiResponse<T> {
  success: boolean;
  generated_at: string;
  api_version: string;
  data: T;
}

export async function fetchFund(
  id: number
): Promise<FundDetails> {
  const { data } = await api.get<ApiResponse<FundDetails>>(
    `/funds/${id}`
  );

  return data.data;
}