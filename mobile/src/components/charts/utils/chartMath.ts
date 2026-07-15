import {
  ChartPoint,
  TimeSeriesPoint,
} from "../types";

const DEFAULT_PADDING = 16;

export function getMinValue(
  data: TimeSeriesPoint[]
): number {
  return Math.min(...data.map((p) => p.value));
}

export function getMaxValue(
  data: TimeSeriesPoint[]
): number {
  return Math.max(...data.map((p) => p.value));
}

export function normalize(
  value: number,
  min: number,
  max: number
) {
  if (max === min) {
    return 0.5;
  }

  return (value - min) / (max - min);
}

export function toChartPoints(
  data: TimeSeriesPoint[],
  width: number,
  height: number,
  padding = DEFAULT_PADDING
): ChartPoint[] {
  if (data.length === 0) {
    return [];
  }

  const min = getMinValue(data);
  const max = getMaxValue(data);

  const usableWidth = width - padding * 2;
  const usableHeight = height - padding * 2;

  return data.map((point, index) => ({
    x:
      padding +
      (index / Math.max(data.length - 1, 1)) *
        usableWidth,

    y:
      padding +
      (1 -
        normalize(
          point.value,
          min,
          max
        )) *
        usableHeight,
  }));
}