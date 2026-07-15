import {
  useMemo,
  useState,
} from "react";

import {
  TimeSeriesPoint,
} from "../types";

type TooltipState = {
  index: number;

  point: TimeSeriesPoint | null;

  x: number;

  y: number;

  visible: boolean;
};

export default function useTooltip(
  data: TimeSeriesPoint[],
  width: number,
  height: number = 220
) {
  const [tooltip, setTooltip] =
    useState<TooltipState>({
      index: -1,
      point: null,
      x: 0,
      y: 0,
      visible: false,
    });

  const step = useMemo(() => {
    if (data.length <= 1) {
      return width;
    }

    return width / (data.length - 1);
  }, [data, width]);

  const min = useMemo(() => {
    if (!data.length) {
      return 0;
    }

    return Math.min(
      ...data.map((p) => p.value)
    );
  }, [data]);

  const max = useMemo(() => {
    if (!data.length) {
      return 1;
    }

    return Math.max(
      ...data.map((p) => p.value)
    );
  }, [data]);

  function show(locationX: number) {
    if (!data.length) {
      return;
    }

    const index = Math.max(
      0,
      Math.min(
        data.length - 1,
        Math.round(locationX / step)
      )
    );

    const point = data[index];

    const range = Math.max(
      max - min,
      0.000001
    );

    const x = index * step;

    const y =
      height -
      ((point.value - min) / range) *
        height;

    setTooltip({
      index,
      point,
      x,
      y,
      visible: true,
    });
  }

  function hide() {
    setTooltip((current) => ({
      ...current,
      visible: false,
    }));
  }

  return {
    tooltip,
    show,
    hide,
  };
}