export default function formatPercentage(
  value?: number | string | null,
  decimals = 2
): string {
  if (value === null || value === undefined || value === "") {
    return "--";
  }

  const numeric =
    typeof value === "string"
      ? parseFloat(value)
      : value;

  if (Number.isNaN(numeric)) {
    return "--";
  }

  return `${(numeric * 100).toFixed(decimals)}%`;
}