import React, {
  useState,
} from "react";

import {
  View,
  StyleSheet,
} from "react-native";

import ChartCard from "./ChartCard";
import ChartToolbar from "./ChartToolbar";
import ChartXAxis from "./ChartXAxis";
import ChartYAxis from "./ChartYAxis";
import ChartGrid from "./ChartGrid";
import ChartSurface from "./ChartSurface";

import useChartDimensions from "./hooks/useChartDimensions";

import type {
  ChartRange,
  TimeSeriesPoint,
} from "./types";

type Props = {
  title: string;

  subtitle?: string;

  rightLabel?: string;

  data: TimeSeriesPoint[];

  range: ChartRange;

  onRangeChange: (
    range: ChartRange,
  ) => void;

  onMove?: (
    x: number,
  ) => void;

  onEnd?: () => void;

  children: (dimensions: {
    width: number;
    height: number;
  }) => React.ReactNode;
};

export default function ChartContainer({
  title,
  subtitle,
  rightLabel,
  data,
  range,
  onRangeChange,
  onMove,
  onEnd,
  children,
}: Props) {
  const {
    height,
  } = useChartDimensions();

  /*
   * This is the actual width available to the
   * chart AFTER the Y-axis has taken its 56px.
   */
  const [
    surfaceWidth,
    setSurfaceWidth,
  ] = useState(0);

  return (
    <ChartCard
      title={title}
      subtitle={subtitle}
      rightLabel={rightLabel}
    >
      <ChartToolbar
        value={range}
        onChange={
          onRangeChange
        }
      />

      <View
        style={
          styles.chartRow
        }
      >
        <ChartYAxis
          data={data}
          width={56}
          height={height}
        />

        <View
          style={
            styles.surfaceContainer
          }
          onLayout={(event) => {
            const measuredWidth =
              event.nativeEvent
                .layout.width;

            setSurfaceWidth(
              measuredWidth,
            );
          }}
        >
          {surfaceWidth > 0 && (
            <>
              <View
                style={[
                  styles.surfaceLayer,
                  {
                    width:
                      surfaceWidth,

                    height,
                  },
                ]}
              >
                <ChartGrid
                  width={
                    surfaceWidth
                  }
                  height={height}
                />

                <ChartSurface
                  width={
                    surfaceWidth
                  }
                  height={height}
                  onMove={onMove}
                  onEnd={onEnd}
                >
                  {({
                    width:
                      innerWidth,

                    height:
                      innerHeight,
                  }) =>
                    children({
                      width:
                        innerWidth,

                      height:
                        innerHeight,
                    })
                  }
                </ChartSurface>
              </View>

              <ChartXAxis
                width={
                  surfaceWidth
                }
                data={data}
                range={range}
              />
            </>
          )}
        </View>
      </View>
    </ChartCard>
  );
}

const styles =
  StyleSheet.create({
    chartRow: {
      width: "100%",

      flexDirection:
        "row",

      alignItems:
        "flex-start",

      minWidth: 0,
    },

    surfaceContainer: {
      flex: 1,

      minWidth: 0,

      overflow:
        "hidden",
    },

    surfaceLayer: {
      position:
        "relative",

      width: "100%",
    },
  });