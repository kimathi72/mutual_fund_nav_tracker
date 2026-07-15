import React from "react";
import { View } from "react-native";

import {
  Canvas,
  Path,
  Skia,
} from "@shopify/react-native-skia";

type Props = {
  values: number[];
  width?: number;
  height?: number;
};

export default function AreaPerformanceChart({
  values,
  width = 340,
  height = 180,
}: Props) {
  if (values.length < 2) {
    return <View style={{ height }} />;
  }

  const min = Math.min(...values);
  const max = Math.max(...values);

  const range = Math.max(max - min, 0.0001);

  const step = width / (values.length - 1);

  const line = Skia.Path.Make();

  values.forEach((v, i) => {
    const x = i * step;

    const y =
      height -
      ((v - min) / range) * (height - 24);

    if (i === 0) line.moveTo(x, y);
    else line.lineTo(x, y);
  });

  const area = line.copy();

  area.lineTo(width, height);
  area.lineTo(0, height);
  area.close();

  return (
    <Canvas
      style={{
        width,
        height,
      }}
    >
      <Path
        path={area}
        color="rgba(30,58,138,0.15)"
      />

      <Path
        path={line}
        color="#1E3A8A"
        style="stroke"
        strokeWidth={3}
      />
    </Canvas>
  );
}