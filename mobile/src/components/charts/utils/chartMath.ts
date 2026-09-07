import {
  TimeSeriesPoint,
} from "../types";

export interface ChartDomain {
  min: number;
  max: number;
  range: number;
}

/*
|--------------------------------------------------------------------------
| Shared Y-Domain
|--------------------------------------------------------------------------
*/

export function getChartDomain(
  data: TimeSeriesPoint[],
): ChartDomain {
  if (!data.length) {
    return {
      min: 0,
      max: 1,
      range: 1,
    };
  }

  const values =
    data.map(
      p => p.value,
    );

  const actualMin =
    Math.min(...values);

  const actualMax =
    Math.max(...values);

  const actualRange =
    actualMax - actualMin;

  const minPadding =
    actualRange === 0
      ? Math.abs(actualMin) * 0.05
      : actualRange * 0.10;

  const maxPadding =
    actualRange === 0
      ? Math.abs(actualMax) * 0.05
      : actualRange * 0.05;

  /*
   * Prevent a zero-domain problem when
   * the data value is exactly 0.
   */
  const safeMinPadding =
    minPadding === 0
      ? 0.05
      : minPadding;

  const safeMaxPadding =
    maxPadding === 0
      ? 0.05
      : maxPadding;

  const displayMin =
    actualMin -
    safeMinPadding;

  const displayMax =
    actualMax +
    safeMaxPadding;

  return {
    min: displayMin,
    max: displayMax,
    range:
      displayMax -
      displayMin,
  };
}

/*
|--------------------------------------------------------------------------
| Shared Coordinate Transform
|--------------------------------------------------------------------------
|
| IMPORTANT:
|
| width and height here represent the INNER
| plotting area, not the entire chart surface.
|
| ChartSurface is responsible for translating
| this coordinate system by paddingLeft/paddingTop.
|
|--------------------------------------------------------------------------
*/

export function toChartPoints(
  data: TimeSeriesPoint[],
  width: number,
  height: number,
) {
  const domain =
    getChartDomain(data);

  if (!data.length) {
    return [];
  }

  return data.map(
    (item, index) => ({
      x:
        data.length <= 1
          ? width / 2
          : (
              index /
              (data.length - 1)
            ) * width,

      y:
        height -
        (
          (
            item.value -
            domain.min
          ) /
          domain.range
        ) *
        height,

      value:
        item.value,

      date:
        item.date,
    }),
  );
}

export function getMinValue(
  data: TimeSeriesPoint[],
) {
  return getChartDomain(data)
    .min;
}

export function getMaxValue(
  data: TimeSeriesPoint[],
) {
  return getChartDomain(data)
    .max;
}