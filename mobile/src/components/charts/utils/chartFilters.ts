import { TimeSeriesPoint } from "../types";

export type ChartRange =
  | "week"
  | "month"
  | "year";

export function filterChartData(
  history: TimeSeriesPoint[],
  range: ChartRange
): TimeSeriesPoint[] {
  switch (range) {
    case "week":
      return history.slice(-7);

    case "month":
      return history.slice(-30);

    case "year":
      return history.slice(-365);

    default:
      return history;
  }
}