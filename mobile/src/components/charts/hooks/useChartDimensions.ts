import {
  useWindowDimensions,
} from "react-native";

export default function useChartDimensions() {
  const { width } =
    useWindowDimensions();

  return {
    width: Math.min(
      width - 32,
      900
    ),

    height:
      width < 430
        ? 180
        : 240,

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