// components/charts/types.ts

/*
|--------------------------------------------------------------------------
| Chart ranges
|--------------------------------------------------------------------------
*/

export type ChartRange =
  | "1W"
  | "1M"
  | "3M"
  | "6M"
  | "1Y"
  | "ALL";

/*
|--------------------------------------------------------------------------
| Historical time-series point
|--------------------------------------------------------------------------
*/

export interface TimeSeriesPoint {
  date: string;
  value: number;
}

/*
|--------------------------------------------------------------------------
| Forecast point
|--------------------------------------------------------------------------
|
| Represents a predicted value for a future target date.
|
| lower / upper are optional because some forecast responses
| may not provide prediction bounds.
|--------------------------------------------------------------------------
*/

export interface ForecastPoint {
  date: string;
  value: number;
  lower?: number;
  upper?: number;
}

/*
|--------------------------------------------------------------------------
| Historical prediction point
|--------------------------------------------------------------------------
|
| Used when the API exposes previously generated predictions
| that are displayed as a time series.
|--------------------------------------------------------------------------
*/

export interface PredictionHistoryPoint {
  date: string;
  value: number;
}

/*
|--------------------------------------------------------------------------
| Forecast chart series
|--------------------------------------------------------------------------
|
| The forecast chart receives:
|
| actual    -> historical NAV
| oneDay    -> 1-day predictions
| thirtyDay -> 30-day predictions
| ninetyDay -> 90-day predictions
|--------------------------------------------------------------------------
*/

export interface ForecastChartSeries {
  actual: TimeSeriesPoint[];
  oneDay: PredictionHistoryPoint[];
  thirtyDay: PredictionHistoryPoint[];
  ninetyDay: PredictionHistoryPoint[];
}

/*
|--------------------------------------------------------------------------
| Shared chart renderer props
|--------------------------------------------------------------------------
|
| All chart renderers must support:
|
| - data
| - width
| - height
| - color
| - strokeWidth
| - dashed
|
| `dashed` is especially important for forecast lines.
|--------------------------------------------------------------------------
*/

export interface RendererProps {
  data: TimeSeriesPoint[];
  width: number;
  height: number;
  color?: string;
  strokeWidth?: number;
  dashed?: boolean;
}

/*
|--------------------------------------------------------------------------
| Area renderer props
|--------------------------------------------------------------------------
*/

export interface AreaRendererProps
  extends RendererProps {
  fillColor?: string;
}

/*
|--------------------------------------------------------------------------
| Internal chart point
|--------------------------------------------------------------------------
*/

export interface ChartPoint {
  x: number;
  y: number;
}

/*
|--------------------------------------------------------------------------
| Heat map
|--------------------------------------------------------------------------
*/

export interface HeatMapCell {
  label: string;
  value: number;
}

export interface HeatMapProps {
  data: HeatMapCell[];
  width: number;
  height: number;
}

/*
|--------------------------------------------------------------------------
| Tooltip
|--------------------------------------------------------------------------
*/

export interface TooltipPoint {
  index: number;
  x: number;
  y: number;
  value: number;
  label: string;
}