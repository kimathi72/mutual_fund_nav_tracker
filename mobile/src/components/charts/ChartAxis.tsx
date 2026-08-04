import React from "react";

import {

  View,

  StyleSheet,

} from "react-native";

import AppText from "@/components/common/AppText";

import {

  getChartDimensions,

} from "./utils/chartDimensions";

type Props = {

  width:number;

  height:number;

  min:number;

  max:number;

};

export default function ChartAxis({

  width,

  height,

  min,

  max,

}:Props){

  const chart = getChartDimensions(width,height);

  const values = [

    max,

    max-(max-min)/4,

    max-(max-min)/2,

    max-(max-min)*0.75,

    min,

  ];

  return(

    <View

      pointerEvents="none"

      style={StyleSheet.absoluteFill}

    >

      {values.map((value,index)=>(

        <AppText

          key={index}

          style={{

            position:"absolute",

            left:0,

            top:

              chart.paddingTop+

              (chart.innerHeight/4)*index-

              8,

            fontSize:10,

            color:"#6B7280",

          }}

        >

          {value.toFixed(2)}

        </AppText>

      ))}

    </View>

  );

}