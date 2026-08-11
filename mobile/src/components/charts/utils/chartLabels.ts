import {
  ChartRange,
  TimeSeriesPoint,
} from "../types";

export type ChartTick = {
  index: number;
  label: string;
};

function formatDate(
  date: Date,
  range: ChartRange
) {
  switch (range) {
    case "1W":
      return date.toLocaleDateString("en-US", {
        weekday: "short",
      });

    case "1M":
      return date.toLocaleDateString("en-US", {
        day: "2-digit",
        month: "short",
      });

    case "3M":
      return date.toLocaleDateString("en-US", {
        month: "short",
      });

    case "YTD":
      return date.toLocaleDateString("en-US", {
        month: "short",
      });

    case "1Y":
      return date.toLocaleDateString("en-US", {
        month: "short",
      });

    case "3Y":
      return date.toLocaleDateString("en-US", {
        year: "numeric",
      });

    case "MAX":
      return date.toLocaleDateString("en-US", {
        year: "numeric",
      });

    default:
      return "";
  }
}

export function buildXAxisLabels(
  data: TimeSeriesPoint[],
  range: ChartRange
): ChartTick[] {
  if (!data.length) {
    return [];
  }

  let divisions = 6;

  switch (range) {
    case "1W":
      divisions = 7;
      break;

    case "1M":
      divisions = 5;
      break;

    case "3M":
      divisions = 6;
      break;

    case "YTD":
      divisions = 7;
      break;

    case "1Y":
      divisions = 6;
      break;

    case "3Y":
      divisions = 4;
      break;

    case "MAX":
      divisions = 5;
      break;
  }

  const step = Math.max(
    1,
    Math.floor((data.length - 1) / (divisions - 1))
  );

  const ticks: ChartTick[] = [];

  for (
    let i = 0;
    i < data.length;
    i += step
  ) {
    ticks.push({
      index: i,
      label: formatDate(
        new Date(data[i].date),
        range
      ),
    });
  }

  if (
    ticks[ticks.length - 1].index !==
    data.length - 1
  ) {
    ticks.push({
      index: data.length - 1,
      label: formatDate(
        new Date(
          data[data.length - 1].date
        ),
        range
      ),
    });
  }

  return ticks;
}