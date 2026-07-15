import React from "react";

import ChartCard from "./ChartCard";
import ChartSurface from "./ChartSurface";

import { HeatMapRenderer } from "./renderers";

import { HeatMapCell } from "./types";

type Props = {
  data: HeatMapCell[];

  width?: number;

  height?: number;
};

export default function RiskHeatMap({
  data,
  width = 340,
  height = 120,
}: Props) {
  if (!data || data.length === 0) {
    return null;
  }

  return (
    <ChartCard
      title="Risk Heat Map"
      subtitle="Current risk exposure"
    >
      <ChartSurface
        width={width}
        height={height}
      >
        <HeatMapRenderer
          data={data}
          width={width}
          height={height}
        />
      </ChartSurface>
    </ChartCard>
  );
}