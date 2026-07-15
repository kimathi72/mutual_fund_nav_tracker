export default function formatCurrency(
  value?: number | string | null | undefined,
  currency = "USD"
): string {
  if (value === null || value === undefined || value === "") {
    return "--";
  }

  const numeric =
    typeof value === "string"
      ? Number(value)
      : value;

  if (Number.isNaN(numeric)) {
    return "--";
  }

  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency,
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(numeric);
}