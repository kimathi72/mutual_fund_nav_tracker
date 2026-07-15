import React from "react";
import { View } from "react-native";

import {
  Canvas,
  Path,
  Skia,
} from "@shopify/react-native-skia";

type Point = {
  value: number;
};

type Props = {
  history: Point[];
  forecast: Point[];
  width?: number;
  height?: number;
};

export default function ForecastChart({
  history,
  forecast,
  width = 340,
  height = 180,
}: Props) {
  if (!history.length) {
    return <View style={{ height }} />;
  }

  const all = [
    ...history.map(x => x.value),
    ...forecast.map(x => x.value),
  ];

  const min = Math.min(...all);

  const max = Math.max(...all);

  const range = Math.max(max - min, 0.0001);

  const total =
    history.length + forecast.length;

  const step = width / Math.max(total - 1, 1);

  const historical = Skia.Path.Make();

  history.forEach((p, i) => {
    const x = i * step;

    const y =
      height -
      ((p.value - min) / range) * (height - 20);

    if (i === 0) historical.moveTo(x, y);
    else historical.lineTo(x, y);
  });

  const prediction = Skia.Path.Make();

  if (forecast.length) {
    const lastX =
      (history.length - 1) * step;

    const lastY =
      height -
      ((history.at(-1)!.value - min) / range) *
        (height - 20);

    prediction.moveTo(lastX, lastY);

    forecast.forEach((p, i) => {
      const x =
        (history.length + i) * step;

      const y =
        height -
        ((p.value - min) / range) *
          (height - 20);

      prediction.lineTo(x, y);
    });
  }

  return (
    <Canvas
      style={{
        width,
        height,
      }}
    >
      <Path
        path={historical}
        color="#1E3A8A"
        style="stroke"
        strokeWidth={3}
      />

      <Path
        path={prediction}
        color="#16A34A"
        style="stroke"
        strokeWidth={3}
      />
    </Canvas>
  );
}