import React from "react";

import {
  Canvas,
  Line,
} from "@shopify/react-native-skia";

import Colors from "@/constants/colors";

type Props = {
  width: number;
  height: number;
  rows?: number;
};

export default function ChartGrid({
  width,
  height,
  rows = 5,
}: Props) {
  const rowHeight = height / rows;

  return (
    <Canvas
      style={{
        position: "absolute",
        width,
        height,
      }}
    >
      {Array.from({ length: rows + 1 }).map((_, index) => (
        <Line
          key={index}
          p1={{ x: 0, y: index * rowHeight }}
          p2={{ x: width, y: index * rowHeight }}
          color={Colors.border}
          strokeWidth={1}
        />
      ))}
    </Canvas>
  );
}