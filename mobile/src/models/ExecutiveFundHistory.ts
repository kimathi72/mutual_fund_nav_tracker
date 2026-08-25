import { NavPoint } from "./NavPoint";
import { VolatilityPoint } from "./VolatilityPoint";
import { PredictionPoint } from "./PredictionPoint";

export interface ExecutiveFundHistory {
    nav: NavPoint[];

    volatility: VolatilityPoint[];

    prediction_history: PredictionPoint[];
}