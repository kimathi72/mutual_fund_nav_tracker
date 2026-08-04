import React from "react";

import {
  Platform,
  View,
  PanResponder,
} from "react-native";

import { Canvas } from "@shopify/react-native-skia";

import Svg from "react-native-svg";

import {
  getChartDimensions,
} from "./utils/chartDimensions";

type Props = {

  width:number;

  height:number;

  children:React.ReactNode;

  onMove?:(x:number)=>void;

  onEnd?:()=>void;

};

export default function ChartSurface({

  width,

  height,

  children,

  onMove,

  onEnd,

}:Props){

  const chart =
    getChartDimensions(
      width,
      height
    );

  const responder =
    PanResponder.create({

      onStartShouldSetPanResponder:()=>true,

      onMoveShouldSetPanResponder:()=>true,

      onPanResponderGrant:e=>{

        onMove?.(
          e.nativeEvent.locationX
        );

      },

      onPanResponderMove:e=>{

        onMove?.(
          e.nativeEvent.locationX
        );

      },

      onPanResponderRelease:()=>{

        onEnd?.();

      },

      onPanResponderTerminate:()=>{

        onEnd?.();

      }

    });

  if(
    Platform.OS==="web"
  ){

    return(

      <View
        {...responder.panHandlers}
      >

        <Svg
          width={chart.width}
          height={chart.height}
        >

          <g

            transform={

              `translate(

              ${chart.paddingLeft},

              ${chart.paddingTop}

              )`

            }

          >

            {children}

          </g>

        </Svg>

      </View>

    );

  }

  return(

    <View
      {...responder.panHandlers}
    >

      <Canvas

        style={{

          width:chart.width,

          height:chart.height

        }}

      >

        {children}

      </Canvas>

    </View>

  );

}