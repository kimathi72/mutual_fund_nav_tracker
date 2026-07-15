import React, {
  useMemo,
} from "react";

import {
  Skia,
  Path,
} from "@shopify/react-native-skia";

import {
  normalizePoints,
} from "./ChartMath";

type Props = {

  values: number[];

  width: number;

  height: number;

  color: string;

};

export default function LinePath({

  values,

  width,

  height,

  color,

}: Props) {

  const path = useMemo(() => {

    const pts =
      normalizePoints(
        values,
        width,
        height
      );

    const p = Skia.Path.Make();

    if (!pts.length)
      return p;

    p.moveTo(
      pts[0].x,
      pts[0].y
    );

    pts.slice(1).forEach(point => {

      p.lineTo(
        point.x,
        point.y
      );

    });

    return p;

  }, [
    values,
    width,
    height,
  ]);

  return (
    <Path
      path={path}
      color={color}
      style="stroke"
      strokeWidth={3}
    />
  );

}