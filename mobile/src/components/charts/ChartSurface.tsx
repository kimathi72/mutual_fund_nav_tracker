import React from "react";

import {
  Platform,
  View,
  PanResponder,
  StyleSheet,
} from "react-native";

import {
  Canvas,
  Group,
} from "@shopify/react-native-skia";

import Svg, {
  G,
} from "react-native-svg";

import {
  getChartDimensions,
} from "./utils/chartDimensions";

type Props = {
  width: number;
  height: number;

  children: (dimensions: {
    width: number;
    height: number;
  }) => React.ReactNode;

  onMove?: (
    x: number,
  ) => void;

  onEnd?: () => void;
};

export default function ChartSurface({
  width,
  height,
  children,
  onMove,
  onEnd,
}: Props) {
  const chart =
    getChartDimensions(
      width,
      height,
    );

  const responder =
    PanResponder.create({
      onStartShouldSetPanResponder:
        () => true,

      onMoveShouldSetPanResponder:
        () => true,

      onPanResponderGrant:
        event => {
          onMove?.(
            event.nativeEvent
              .locationX -
              chart.paddingLeft,
          );
        },

      onPanResponderMove:
        event => {
          onMove?.(
            event.nativeEvent
              .locationX -
              chart.paddingLeft,
          );
        },

      onPanResponderRelease:
        () => {
          onEnd?.();
        },

      onPanResponderTerminate:
        () => {
          onEnd?.();
        },
    });

  if (
    Platform.OS === "web"
  ) {
    return (
      <View
        {...responder.panHandlers}
        style={[
          styles.webSurface,
          {
            width:
              chart.width,

            height:
              chart.height,
          },
        ]}
      >
        <Svg
          width={chart.width}
          height={chart.height}
          viewBox={`0 0 ${chart.width} ${chart.height}`}
          style={styles.svg}
        >
          <G
            x={chart.paddingLeft}
            y={chart.paddingTop}
          >
            {children({
              width:
                chart.innerWidth,

              height:
                chart.innerHeight,
            })}
          </G>
        </Svg>
      </View>
    );
  }

  return (
    <View
      {...responder.panHandlers}
      style={[
        styles.nativeSurface,
        {
          width:
            chart.width,

          height:
            chart.height,
        },
      ]}
    >
      <Canvas
        style={{
          width:
            chart.width,

          height:
            chart.height,
        }}
      >
        <Group
          transform={[
            {
              translateX:
                chart.paddingLeft,
            },
            {
              translateY:
                chart.paddingTop,
            },
          ]}
        >
          {children({
            width:
              chart.innerWidth,

            height:
              chart.innerHeight,
          })}
        </Group>
      </Canvas>
    </View>
  );
}

const styles =
  StyleSheet.create({
    webSurface: {
      position:
        "relative",

      overflow:
        "hidden",
    },

    svg: {
      position:
        "absolute",

      left: 0,
      top: 0,
    },

    nativeSurface: {
      position:
        "relative",

      overflow:
        "hidden",
    },
  });