import { useLocalSearchParams } from "expo-router";

import FundDetailsScreen from "@/screens/fund/FundDetailsScreen";

export default function FundPage() {
  const { id } = useLocalSearchParams<{
    id: string;
  }>();

  return (
    <FundDetailsScreen
      id={Number(id)}
    />
  );
}