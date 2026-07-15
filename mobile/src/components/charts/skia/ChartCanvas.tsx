import React from "react";

import {
  Canvas, Skia
} from "@shopify/react-native-skia";

type Props = {
  width: number;
  height: number;
  children: React.ReactNode;
};

export default function ChartCanvas({
  width,
  height,
  children,
}: Props) {
      if (!Skia) {
        return null;
      }
  return (

    <Canvas
      style={{
        width,
        height,
      }}
    >
      {children}
    </Canvas>

  );
}