import client from "./client";

export async function fetchFundDetails(id: number) {
  const response = await client.get(`/funds/${id}`);

  return response.data.data;
}