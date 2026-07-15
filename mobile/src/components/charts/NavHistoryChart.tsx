import React from "react";
import { Dimensions, View } from "react-native";

import ChartCard from "./ChartCard";
import ChartSurface from "./ChartSurface";
import ChartTooltip from "./ChartTooltip";
import { CrosshairRenderer } from "./renderers";
import { LineRenderer } from "./renderers";

import useTooltip from "./hooks/useTooltip";

import ExecutiveChartTheme from "./ExecutiveChartTheme";

import {
  TimeSeriesPoint,
} from "./types";

type Props = {
  history: TimeSeriesPoint[];
};

const WIDTH =
  Dimensions.get("window").width - 48;

const HEIGHT = 220;

export default function NavHistoryChart({
  history,
}: Props) {
  const {
    tooltip,
    show,
    hide,
  } = useTooltip(
    history,
    WIDTH,
    HEIGHT
  );

  if (history.length < 2) {
    return null;
  }

  return (
    <ChartCard
      title="NAV History"
      subtitle={`${history.length} trading days`}
    >
      <View>

       <ChartSurface
          width={WIDTH}
          height={HEIGHT}
          onMove={show}
          onEnd={hide}
        >
          <LineRenderer
            data={history}
            width={WIDTH}
            height={HEIGHT}
            color={ExecutiveChartTheme.line}
          />

          {tooltip.visible && (
            <CrosshairRenderer
              x={tooltip.x}
              y={tooltip.y}
              height={HEIGHT}
            />
          )}
        </ChartSurface>

        <ChartTooltip
          visible={tooltip.visible}
          x={tooltip.x}
          y={tooltip.y}
          label={tooltip.point?.date ?? ""}
          value={
            tooltip.point?.value.toFixed(2) ?? ""
          }
        />

      </View>
    </ChartCard>
  );
}