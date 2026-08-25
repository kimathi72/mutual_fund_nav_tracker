import React, { useMemo, useState } from "react";

import ChartContainer from "./ChartContainer";

import LineRenderer from "./renderers/LineRenderer";
import CrossHairRenderer from "./renderers/CrossHairRenderer";

import ChartTooltip from "./ChartTooltip";

import useTooltip from "./hooks/useTooltip";

import ExecutiveChartTheme from "./ExecutiveChartTheme";

import { TimeSeriesPoint, ChartRange } from "./types";

import { filterChartData } from "./utils/chartFilters";

type Props = {
  history: TimeSeriesPoint[];
};

export default function NavHistoryChart({ history }: Props) {
  const [range, setRange] = useState<ChartRange>("1M");

  const filteredHistory = useMemo(
    () => filterChartData(history, range),
    [history, range],
  );

  const { tooltip, show, hide } = useTooltip(filteredHistory, 1, 1);

  if (filteredHistory.length < 2) {
    return null;
  }

  return (
    <ChartContainer
      title="NAV History"
      subtitle={`${filteredHistory.length} observations`}
      range={range}
      onRangeChange={setRange}
      data={filteredHistory}
      onMove={show}
      onEnd={hide}
    >
      {({ width, height }) => (
        <>
          <LineRenderer
            data={filteredHistory}
            width={width}
            height={height}
            color={ExecutiveChartTheme.colors.historical}
          />

          {tooltip.visible && (
            <CrossHairRenderer
              x={tooltip.x}
              y={tooltip.y}
              width={width}
              height={height}
            />
          )}

          <ChartTooltip
            visible={tooltip.visible}
            x={tooltip.x}
            y={tooltip.y}
            label={tooltip.point?.date ?? ""}
            value={tooltip.point ? tooltip.point.value.toFixed(2) : ""}
          />
        </>
      )}
    </ChartContainer>
  );
}
