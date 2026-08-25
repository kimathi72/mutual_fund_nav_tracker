import { Skia } from "@shopify/react-native-skia";

import { ChartPoint } from "../types";

export function buildLinePath(
  points: ChartPoint[]
) {
  const path = Skia.Path.Make();

  if (points.length === 0) {
    return path;
  }

  path.moveTo(
    points[0].x,
    points[0].y
  );

  for (let i = 1; i < points.length; i++) {
    path.lineTo(
      points[i].x,
      points[i].y
    );
  }

  return path;
}