
// utils/formatCurrency.ts

export default function formatCurrency(
  value?: number | string | null,
  currency = "USD",
): string {
  if (value === null || value === undefined || value === "") {
    return "--";
  }

  const numeric =
    typeof value === "string"
      ? Number(value)
      : value;

  if (!Number.isFinite(numeric)) {
    return "--";
  }

  const normalizedCurrency =
    String(currency || "USD")
      .trim()
      .toUpperCase();

  try {
    return new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: normalizedCurrency,
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(numeric);
  } catch {
    return "--";
  }
}
