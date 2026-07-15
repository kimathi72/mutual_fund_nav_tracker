import colors from "@/constants/colors";

export default function riskColor(
  risk?: string | null
): string {
  switch (risk?.toLowerCase()) {
    case "low":
      return colors.success;

    case "medium":
      return colors.warning;

    case "high":
      return colors.danger;

    default:
      return colors.subtitle;
  }
}