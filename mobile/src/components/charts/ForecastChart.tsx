import React, {
  useMemo,
  useState,
} from "react";

import ChartContainer from "./ChartContainer";

import {
  LineRenderer,
} from "./renderers";

import ExecutiveChartTheme
  from "./ExecutiveChartTheme";

import type {
  ChartRange,
  PredictionHistoryPoint,
  TimeSeriesPoint,
} from "./types";

import {
  filterChartData,
} from "./utils/chartFilters";

type Props = {
  history: TimeSeriesPoint[];

  oneDayPredictions:
    PredictionHistoryPoint[];

  thirtyDayPredictions:
    PredictionHistoryPoint[];

  ninetyDayPredictions:
    PredictionHistoryPoint[];
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

const HORIZON_COLORS = {
  oneDay:
    ExecutiveChartTheme.colors
      .forecast,

  thirtyDay:
    "#8B5CF6",

  ninetyDay:
    "#F59E0B",
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

function sortByDate<
  T extends {
    date: string;
  },
>(
  data: T[],
): T[] {
  return [...data].sort(
    (a, b) =>
      getTime(a.date) -
      getTime(b.date),
  );
}

function normalizeSeries<
  T extends {
    date: string;
    value: number;
  },
>(
  data: T[],
): T[] {
  return sortByDate(
    data.filter(
      (point) =>
        Boolean(point.date) &&
        Number.isFinite(
          point.value,
        ) &&
        Number.isFinite(
          getTime(point.date),
        ),
    ),
  );
}

function deduplicatePredictions(
  data: PredictionHistoryPoint[],
): PredictionHistoryPoint[] {
  const byTarget =
    new Map<
      string,
      PredictionHistoryPoint
    >();

  for (const point of data) {
    if (
      !point.date ||
      !Number.isFinite(point.value)
    ) {
      continue;
    }

    byTarget.set(
      point.date,
      point,
    );
  }

  return sortByDate(
    Array.from(
      byTarget.values(),
    ),
  );
}

function filterFuturePredictions(
  predictions:
    PredictionHistoryPoint[],
  latestActualDate: number,
  range: ChartRange,
): PredictionHistoryPoint[] {
  const rangeDays =
    RANGE_DAYS[range];

  const maxTime =
    rangeDays == null
      ? null
      : latestActualDate +
        rangeDays *
          24 *
          60 *
          60 *
          1000;

  return predictions.filter(
    (point) => {
      const time =
        getTime(point.date);

      if (
        !Number.isFinite(time)
      ) {
        return false;
      }

      if (
        time <= latestActualDate
      ) {
        return false;
      }

      if (
        maxTime == null
      ) {
        return true;
      }

      return time <= maxTime;
    },
  );
}

export default function ForecastChart({
  history,
  oneDayPredictions,
  thirtyDayPredictions,
  ninetyDayPredictions,
}: Props) {
  const [range, setRange] =
    useState<ChartRange>("1M");

  const normalizedHistory =
    useMemo(
      () =>
        normalizeSeries(
          history,
        ),
      [history],
    );

  const latestHistoryPoint =
    normalizedHistory.length > 0
      ? normalizedHistory[
          normalizedHistory.length - 1
        ]
      : null;

  const filteredHistory =
    useMemo(
      () =>
        filterChartData(
          normalizedHistory,
          range,
        ),
      [
        normalizedHistory,
        range,
      ],
    );

  const normalizedOneDay =
    useMemo(
      () =>
        deduplicatePredictions(
          oneDayPredictions,
        ),
      [oneDayPredictions],
    );

  const normalizedThirtyDay =
    useMemo(
      () =>
        deduplicatePredictions(
          thirtyDayPredictions,
        ),
      [
        thirtyDayPredictions,
      ],
    );

  const normalizedNinetyDay =
    useMemo(
      () =>
        deduplicatePredictions(
          ninetyDayPredictions,
        ),
      [
        ninetyDayPredictions,
      ],
    );

  const filteredOneDay =
    useMemo(() => {
      if (
        !latestHistoryPoint
      ) {
        return [];
      }

      return filterFuturePredictions(
        normalizedOneDay,
        getTime(
          latestHistoryPoint.date,
        ),
        range,
      );
    }, [
      normalizedOneDay,
      latestHistoryPoint,
      range,
    ]);

  const filteredThirtyDay =
    useMemo(() => {
      if (
        !latestHistoryPoint
      ) {
        return [];
      }

      return filterFuturePredictions(
        normalizedThirtyDay,
        getTime(
          latestHistoryPoint.date,
        ),
        range,
      );
    }, [
      normalizedThirtyDay,
      latestHistoryPoint,
      range,
    ]);

  const filteredNinetyDay =
    useMemo(() => {
      if (
        !latestHistoryPoint
      ) {
        return [];
      }

      return filterFuturePredictions(
        normalizedNinetyDay,
        getTime(
          latestHistoryPoint.date,
        ),
        range,
      );
    }, [
      normalizedNinetyDay,
      latestHistoryPoint,
      range,
    ]);

  const oneDaySeries =
    useMemo<
      TimeSeriesPoint[]
    >(() => {
      if (
        !latestHistoryPoint ||
        filteredOneDay.length === 0
      ) {
        return [];
      }

      return [
        {
          date:
            latestHistoryPoint.date,
          value:
            latestHistoryPoint.value,
        },
        ...filteredOneDay,
      ];
    }, [
      latestHistoryPoint,
      filteredOneDay,
    ]);

  const thirtyDaySeries =
    useMemo<
      TimeSeriesPoint[]
    >(() => {
      if (
        !latestHistoryPoint ||
        filteredThirtyDay.length === 0
      ) {
        return [];
      }

      return [
        {
          date:
            latestHistoryPoint.date,
          value:
            latestHistoryPoint.value,
        },
        ...filteredThirtyDay,
      ];
    }, [
      latestHistoryPoint,
      filteredThirtyDay,
    ]);

  const ninetyDaySeries =
    useMemo<
      TimeSeriesPoint[]
    >(() => {
      if (
        !latestHistoryPoint ||
        filteredNinetyDay.length === 0
      ) {
        return [];
      }

      return [
        {
          date:
            latestHistoryPoint.date,
          value:
            latestHistoryPoint.value,
        },
        ...filteredNinetyDay,
      ];
    }, [
      latestHistoryPoint,
      filteredNinetyDay,
    ]);

  if (
    filteredHistory.length < 2
  ) {
    return null;
  }

  return (
    <ChartContainer
      title="Forecast"
      subtitle="Actual NAV vs prediction horizons"
      data={filteredHistory}
      range={range}
      onRangeChange={setRange}
    >
      {({
        width,
        height,
      }) => (
        <>
          {/* Actual NAV */}

          <LineRenderer
            data={filteredHistory}
            width={width}
            height={height}
            color={
              ExecutiveChartTheme
                .colors
                .historical
            }
            strokeWidth={2.5}
          />

          {/* 1 Day */}

          {oneDaySeries.length >=
            2 && (
            <LineRenderer
              data={oneDaySeries}
              width={width}
              height={height}
              color={
                HORIZON_COLORS.oneDay
              }
              strokeWidth={2}
              dashed
            />
          )}

          {/* 30 Days */}

          {thirtyDaySeries.length >=
            2 && (
            <LineRenderer
              data={
                thirtyDaySeries
              }
              width={width}
              height={height}
              color={
                HORIZON_COLORS.thirtyDay
              }
              strokeWidth={2}
              dashed
            />
          )}

          {/* 90 Days */}

          {ninetyDaySeries.length >=
            2 && (
            <LineRenderer
              data={
                ninetyDaySeries
              }
              width={width}
              height={height}
              color={
                HORIZON_COLORS.ninetyDay
              }
              strokeWidth={2}
              dashed
            />
          )}
        </>
      )}
    </ChartContainer>
  );
}