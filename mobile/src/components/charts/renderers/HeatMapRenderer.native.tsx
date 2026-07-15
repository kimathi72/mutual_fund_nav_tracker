import React from "react";

import {
  Canvas,
  Rect,
} from "@shopify/react-native-skia";

import { HeatMapProps } from "../types";

export default function HeatMapRenderer({
  data,
  width,
  height,
}: HeatMapProps) {
  if (!data.length) {
    return null;
  }

  const cellWidth = width / data.length;

  return (
    <Canvas
      style={{
        width,
        height,
      }}
    >
      {data.map((cell, index) => {
        const intensity = Math.min(
          Math.abs(cell.value),
          1
        );

        const color =
          cell.value >= 0
            ? `rgba(22,163,74,${0.2 + intensity * 0.8})`
            : `rgba(220,38,38,${0.2 + intensity * 0.8})`;

        return (
          <Rect
            key={cell.label}
            x={index * cellWidth}
            y={0}
            width={cellWidth - 4}
            height={height}
            color={color}
          />
        );
      })}
    </Canvas>
  );
}