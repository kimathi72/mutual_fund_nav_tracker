import {
  useWindowDimensions,
} from "react-native";

const Y_AXIS_WIDTH = 54;

const HORIZONTAL_MARGIN = 32;

const MAX_CHART_WIDTH = 900;

export default function useChartDimensions() {
  const { width } =
    useWindowDimensions();

  const availableWidth =
    Math.min(
      width -
        HORIZONTAL_MARGIN,
      MAX_CHART_WIDTH,
    );

  const chartWidth =
    Math.max(
      1,
      availableWidth -
        Y_AXIS_WIDTH,
    );

  const chartHeight =
    width < 430
      ? 180
      : 240;

  return {
    width: chartWidth,

    height: chartHeight,

    padding:
      width < 430
        ? 24
        : 40,

    labelFont:
      width < 430
        ? 9
        : 11,
  };
}