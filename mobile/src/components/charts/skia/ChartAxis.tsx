import React from "react";

import {
  Canvas,
  Line,
  Text,
  useFont,
} from "@shopify/react-native-skia";

type Props = {
  width: number;
  height: number;
  labels: string[];
};

export default function ChartAxis({
  width,
  height,
  labels,
}: Props) {
  const font = useFont(
    require("../../../assets/fonts/Inter-Regular.ttf"),
    11
  );

  if (!font || labels.length === 0) {
    return null;
  }

  const spacing =
    labels.length > 1
      ? width / (labels.length - 1)
      : width;

  return (
    <Canvas
      style={{
        width,
        height: 26,
      }}
    >
      {labels.map((label, index) => (
        <Text
          key={index}
          x={index * spacing}
          y={18}
          text={label}
          font={font}
        />
      ))}
    </Canvas>
  );
}