import colors from "@/constants/colors";

export default function trendColor(
  trend?: string | null
): string {
  switch (trend?.toLowerCase()) {
    case "bullish":
      return colors.success;

    case "bearish":
      return colors.danger;

    case "neutral":
      return colors.warning;

    default:
      return colors.subtitle;
  }
}