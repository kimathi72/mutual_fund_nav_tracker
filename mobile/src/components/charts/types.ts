export interface ChartPoint {
  x: number;
  y: number;
}

export interface TimeSeriesPoint {
  date: string;
  value: number;
}

export interface ForecastPoint extends TimeSeriesPoint {
  confidence?: number;
}

export interface RendererProps {
  data: TimeSeriesPoint[];

  width: number;

  height: number;

  color?: string;

  strokeWidth?: number;

  dashed?: boolean;
}

export interface AreaRendererProps extends RendererProps {
  fillColor?: string;
}

export interface HeatMapCell {
  label: string;
  value: number;
}

export interface HeatMapProps {
  data: HeatMapCell[];

  width: number;

  height: number;
}

export interface TooltipPoint {
  index: number;

  x: number;

  y: number;

  value: number;

  label: string;
}