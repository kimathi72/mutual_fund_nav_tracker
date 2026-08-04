// components/charts/utils/chartMath.ts

import {
  ChartPoint,
  TimeSeriesPoint,
} from "../types";

export function getMinValue(
  data: TimeSeriesPoint[]
): number {

  if (data.length === 0) {
    return 0;
  }

  return Math.min(
    ...data.map(point => point.value)
  );

}

export function getMaxValue(
  data: TimeSeriesPoint[]
): number {

  if (data.length === 0) {
    return 0;
  }

  return Math.max(
    ...data.map(point => point.value)
  );

}

export function getValueRange(

  data: TimeSeriesPoint[]

) {

  const min = getMinValue(data);

  const max = getMaxValue(data);

  const range = max - min;

  return {

    min,

    max,

    range: range === 0 ? 1 : range,

  };

}

export function normalize(

  value: number,

  min: number,

  max: number

): number {

  if (max === min) {

    return 0.5;

  }

  return (value - min) / (max - min);

}

export function toChartPoints(

  data: TimeSeriesPoint[],

  width: number,

  height: number

): ChartPoint[] {

  if (data.length === 0) {

    return [];

  }

  const {

    min,

    max,

  } = getValueRange(data);

  const lastIndex = Math.max(

    data.length - 1,

    1

  );

  return data.map((point, index) => ({

    x:

      (index / lastIndex) *

      width,

    y:

      (1 -

        normalize(

          point.value,

          min,

          max

        )) *

      height,

  }));

}

export function nearestPoint(

  data: TimeSeriesPoint[],

  chartWidth: number,

  x: number

): number {

  if (data.length <= 1) {

    return 0;

  }

  const ratio =

    Math.max(

      0,

      Math.min(

        1,

        x / chartWidth

      )

    );

  return Math.round(

    ratio *

    (data.length - 1)

  );

}

export function valueToY(

  value: number,

  min: number,

  max: number,

  height: number

): number {

  return (

    1 -

    normalize(

      value,

      min,

      max

    )

  ) * height;

}

export function indexToX(

  index: number,

  total: number,

  width: number

): number {

  if (total <= 1) {

    return 0;

  }

  return (

    index /

    (total - 1)

  ) * width;

}