import colors from "@/constants/colors";

export default function riskColor(
  riskLevel?: string | null
): string {
  switch (riskLevel) {
    case "Low":
      return colors.success;

    case "Medium":
      return colors.warning;

    case "High":
      return colors.danger;

    default:
      return colors.text;
  }
}