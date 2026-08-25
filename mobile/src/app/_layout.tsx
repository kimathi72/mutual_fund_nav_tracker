import { Stack } from "expo-router";
import { QueryProvider } from "@/providers/QueryProvider";

export default function Layout() {
  return (
    <QueryProvider>
      <Stack>
        <Stack.Screen
          name="index"
          options={{
            title: "Executive Dashboard",
          }}
        />

        <Stack.Screen
          name="fund/[id]"
          options={{
            title: "Fund Details",
          }}
        />
        <Stack.Screen
          name="rankings"
          options={{
            title: "Portfolio Rankings",
          }}
        />
        <Stack.Screen
          name="briefing"
          options={{
              title: "Executive Briefing",
          }}
        />
      </Stack>
    </QueryProvider>
  );
}