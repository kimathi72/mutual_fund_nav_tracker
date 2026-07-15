import colors from "@/constants/colors";

export default function riskColor(
  volatility?: number | null
): string {
  if (volatility == null) {
    return colors.text;
  }

  if (volatility < 0.05) {
    return colors.success;
  }

  if (volatility < 0.15) {
    return colors.warning;
  }

  return colors.danger;
}