import colors from "@/constants/colors";

export default function statusColor(
  status?: string
): string {
  switch (status?.toLowerCase()) {
    case "success":
      return colors.success;

    case "warning":
      return colors.warning;

    case "error":
      return colors.danger;

    default:
      return colors.primary;
  }
}