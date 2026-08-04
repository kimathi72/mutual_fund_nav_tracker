import React, {

  useMemo,

} from "react";

import {

  Path,

} from "@shopify/react-native-skia";

import {

  RendererProps,

} from "../types";

import {

  toChartPoints,

} from "../utils/chartMath";

import {

  buildLinePath,

} from "../utils/chartPath";

import {

  getChartDimensions,

} from "../utils/chartDimensions";

import ExecutiveChartTheme from "../ExecutiveChartTheme";

export default function LineRenderer({

  data,

  width,

  height,

  color = ExecutiveChartTheme.colors.historical,

  strokeWidth = ExecutiveChartTheme.chart.strokeWidth,

}: RendererProps) {

  const chart = getChartDimensions(width, height);

  const path = useMemo(() => {

    const points = toChartPoints(

      data,

      chart.innerWidth,

      chart.innerHeight

    ).map(point => ({

      x: point.x + chart.paddingLeft,

      y: point.y + chart.paddingTop,

    }));

    return buildLinePath(points);

  }, [

    data,

    chart,

  ]);

  if (data.length < 2) {

    return null;

  }

  return (

    <Path

      path={path}

      color={color}

      style="stroke"

      strokeWidth={strokeWidth}

    />

  );

}