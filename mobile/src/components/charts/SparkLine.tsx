import React from "react";

import ChartCanvas from "./skia/ChartCanvas";
import LinePath from "./skia/LinePath";

import ExecutiveChartTheme from "./ExecutiveChartTheme";

type Props = {

  values: number[];

  width?: number;

  height?: number;

};

export default function Sparkline({

  values,

  width = 120,

  height = 50,

}: Props) {

  if (values.length < 2)
    return null;

  return (

    <ChartCanvas
      width={width}
      height={height}
    >

      <LinePath
        values={values}
        width={width}
        height={height}
        color={ExecutiveChartTheme.line}
      />

    </ChartCanvas>

  );

}