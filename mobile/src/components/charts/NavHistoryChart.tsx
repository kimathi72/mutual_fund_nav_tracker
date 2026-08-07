import React from "react";

import { Dimensions, View } from "react-native";

import ChartCard from "./ChartCard";
import ChartSurface from "./ChartSurface";
import ChartTooltip from "./ChartTooltip";
import ChartGrid from "./ChartGrid";
import ChartAxis from "./ChartAxis";

import LineRenderer from "./renderers/LineRenderer";
import CrossHairRenderer from "./renderers/CrossHairRenderer";

import useTooltip from "./hooks/useTooltip";

import ExecutiveChartTheme from "./ExecutiveChartTheme";

import { TimeSeriesPoint } from "./types";

import { getMinValue, getMaxValue } from "./utils/chartMath";

type Props = {
  history: TimeSeriesPoint[];
};

const WIDTH = Dimensions.get("window").width - 48;

const HEIGHT = 240;

export default function NavHistoryChart({ history }: Props) {
  const {
    tooltip,

    show,

    hide,
  } = useTooltip(
    history,

    WIDTH,

    HEIGHT,
  );

  if (history.length < 2) {
    return null;
  }

  const min = getMinValue(history);

  const max = getMaxValue(history);

  return (
    <ChartCard
      title="NAV History"
      subtitle={`${history.length} trading days`}
      rightLabel={`High ${max.toFixed(2)}`}
    >
      <View>
        <ChartGrid width={WIDTH} height={HEIGHT} />

        <ChartAxis width={WIDTH} height={HEIGHT} min={min} max={max} />

        <ChartSurface width={WIDTH} height={HEIGHT} onMove={show} onEnd={hide}>
          <LineRenderer
            data={history}
            width={WIDTH}
            height={HEIGHT}
            color={ExecutiveChartTheme.colors.historical}
          />

          {tooltip.visible && (
            <CrossHairRenderer
              x={tooltip.x}
              y={tooltip.y}
              width={WIDTH}
              height={HEIGHT}
            />
          )}
        </ChartSurface>

        <ChartTooltip
          visible={tooltip.visible}
          x={tooltip.x}
          y={tooltip.y}
          label={tooltip.point?.date ?? ""}
          value={tooltip.point?.value.toFixed(2) ?? ""}
        />
      </View>
    </ChartCard>
  );
}
