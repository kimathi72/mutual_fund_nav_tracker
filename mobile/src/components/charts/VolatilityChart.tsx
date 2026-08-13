// components/charts/VolatilityChart.tsx

import React, {
  useMemo,
  useState,
} from "react";

import ChartContainer from "./ChartContainer";
import AreaRenderer from "./renderers/AreaRenderer";

import type {
  ChartRange,
  TimeSeriesPoint,
} from "./types";

import type {
  VolatilityPoint,
} from "@/models/VolatilityPoint";
import ExecutiveChartTheme from "./ExecutiveChartTheme";

type Props = {
  history: VolatilityPoint[];
};

const RANGE_DAYS: Record<
  ChartRange,
  number | null
> = {
  "1W": 7,
  "1M": 30,
  "3M": 90,
  "6M": 180,
  "1Y": 365,
  ALL: null,
};

function getTime(
  date: string,
): number {
  const time =
    new Date(date).getTime();

  return Number.isFinite(time)
    ? time
    : NaN;
}

function normalizeHistory(
  history: VolatilityPoint[],
): TimeSeriesPoint[] {
  return (history ?? [])
    .map((point) => {
      const date =
        String(point.date ?? "");

      const value =
        Number(point.volatility);

      return {
        date,
        value,
        time: getTime(date),
      };
    })
    .filter(
      (point) =>
        Boolean(point.date) &&
        Number.isFinite(point.time) &&
        Number.isFinite(point.value),
    )
    .sort(
      (a, b) =>
        a.time - b.time,
    )
    .map(
      ({
        date,
        value,
      }) => ({
        date,
        value,
      }),
    );
}

function filterByRange(
  data: TimeSeriesPoint[],
  range: ChartRange,
): TimeSeriesPoint[] {
  if (!data.length) {
    return [];
  }

  if (range === "ALL") {
    return data;
  }

  const days =
    RANGE_DAYS[range];

  if (days == null) {
    return data;
  }

  const latest =
    getTime(
      data[data.length - 1].date,
    );

  if (!Number.isFinite(latest)) {
    return data;
  }

  const cutoff =
    latest -
    days *
      24 *
      60 *
      60 *
      1000;

  return data.filter(
    (point) =>
      getTime(point.date) >=
      cutoff,
  );
}

export default function VolatilityChart({
  history,
}: Props) {
  const [range, setRange] =
    useState<ChartRange>(
      "1M",
    );

  const normalized =
    useMemo(
      () =>
        normalizeHistory(
          history,
        ),
      [history],
    );

  const filtered =
    useMemo(
      () =>
        filterByRange(
          normalized,
          range,
        ),
      [
        normalized,
        range,
      ],
    );

  if (
    filtered.length < 2
  ) {
    if (__DEV__) {
      console.warn(
        "[VolatilityChart] Not enough valid points",
        {
          received:
            history?.length ?? 0,

          normalized:
            normalized.length,

          filtered:
            filtered.length,

          range,
        },
      );
    }

    return null;
  }

  return (
    <ChartContainer
      title="Volatility"
      subtitle={`${filtered.length} observations`}
      data={filtered}
      range={range}
      onRangeChange={
        setRange
      }
    >
      {({
        width,
        height,
      }) => (
        <AreaRenderer
          data={filtered}
          width={width}
          height={height}
          color={
            ExecutiveChartTheme
              .colors
              .volatility
          }
          fillColor="rgba(245, 158, 11, 0.16)"
        />
      )}
    </ChartContainer>
  );
}