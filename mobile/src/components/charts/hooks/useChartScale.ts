import { useMemo } from "react";

import { TimeSeriesPoint } from "../types";

import { toChartPoints } from "../utils/chartMath";

export default function useChartScale(
  data: TimeSeriesPoint[],
  width: number,
  height: number
) {
  return useMemo(
    () =>
      toChartPoints(
        data,
        width,
        height
      ),
    [
      data,
      width,
      height,
    ]
  );
}