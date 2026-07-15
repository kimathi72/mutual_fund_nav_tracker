import colors from "@/constants/colors";

export default function riskColor(
  risk: number | string
): string {
  if (typeof risk === "number") {
    if (risk < 0.05) return colors.success;
    if (risk < 0.10) return colors.warning;
    return colors.danger;
  }

  switch (risk.toUpperCase()) {
    case "LOW":
      return colors.success;
    case "MEDIUM":
      return colors.warning;
    case "HIGH":
      return colors.danger;
    default:
      return colors.subtitle;
  }
}