import { ChartRange, TimeSeriesPoint } from "../types";


export function filterChartData(
  data: TimeSeriesPoint[],
  range: ChartRange,
): TimeSeriesPoint[] {

  if (data.length === 0)
    return [];

  switch (range) {
    case "1W":
      return data.slice(-7);

    case "1M":
      return data.slice(-30);

    case "3M":
      return data.slice(-90);

    case "YTD":
      return data.filter(item => {
        const d =
          new Date(item.date);

        return (
          d.getFullYear() ===
          new Date().getFullYear()
        );
      });

    case "1Y":
      return data.slice(-365);

    case "3Y":
      return data.slice(-1095);

    case "MAX":
    default:
      return data;
  }
}