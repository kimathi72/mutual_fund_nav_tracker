import {
  Skia,
} from "@shopify/react-native-skia";

import {
  ChartPoint,
} from "../types";

export function buildAreaPath(
  points: ChartPoint[],
  height: number
) {
  const path = Skia.Path.Make();

  if (!points.length) {
    return path;
  }

  path.moveTo(
    points[0].x,
    height
  );

  points.forEach((p) => {
    path.lineTo(
      p.x,
      p.y
    );
  });

  path.lineTo(
    points[points.length - 1].x,
    height
  );

  path.close();

  return path;
}