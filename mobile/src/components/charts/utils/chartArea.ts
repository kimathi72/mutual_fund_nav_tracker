import {
  ChartPoint,
} from "../types";

export function buildAreaSvgPath(
  points: ChartPoint[],
  height: number
): string {
  if (!points.length) {
    return "";
  }

  return [
    `M ${points[0].x} ${height}`,
    ...points.map(
      (p) => `L ${p.x} ${p.y}`
    ),
    `L ${points[points.length - 1].x} ${height}`,
    "Z",
  ].join(" ");
}