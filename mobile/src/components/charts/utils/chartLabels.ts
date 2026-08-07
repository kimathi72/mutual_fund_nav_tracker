import { TimeSeriesPoint } from "../types";
import { ChartRange } from "./chartFilters";

export function buildXAxisLabels(
  history: TimeSeriesPoint[],
  range: ChartRange
) {
  if (!history.length) return [];

  const formatter =
    new Intl.DateTimeFormat("en-GB", {
      day:
        range === "week"
          ? "numeric"
          : undefined,

      month:
        range === "year"
          ? "short"
          : "short",
    });

  let visibleTicks = 5;

  if (range === "week")
    visibleTicks = 7;

  if (range === "year")
    visibleTicks = 6;

  const step = Math.max(
    1,
    Math.floor(
      history.length /
        (visibleTicks - 1)
    )
  );

  const ticks = [];

  for (
    let i = 0;
    i < history.length;
    i += step
  ) {
    ticks.push({
      index: i,
      label: formatter.format(
        new Date(history[i].date)
      ),
    });
  }

  const last =
    history.length - 1;

  if (
    ticks[ticks.length - 1]
      ?.index !== last
  ) {
    ticks.push({
      index: last,
      label: formatter.format(
        new Date(history[last].date)
      ),
    });
  }

  return ticks;
}