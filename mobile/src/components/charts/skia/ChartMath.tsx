export interface ChartPoint {
  x: number;
  y: number;
}

export function normalizePoints(
  values: number[],
  width: number,
  height: number
): ChartPoint[] {

  if (values.length === 0) return [];

  const min = Math.min(...values);
  const max = Math.max(...values);

  const range = max - min || 1;

  return values.map((value, index) => ({

    x:
      (index / (values.length - 1 || 1))
      * width,

    y:
      height -
      ((value - min) / range)
      * height,

  }));
}