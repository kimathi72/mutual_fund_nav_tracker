import React from "react";
import { View, StyleSheet } from "react-native";

import AppText from "../../common/AppText";
import ExecutiveSection from "./ExecutiveSection";

interface Props {
  fund: any;
}

export default function ExecutiveKPIs({
  fund,
}: Props) {

  return (
    <ExecutiveSection title="Executive Snapshot">

      <View style={styles.row}>

        <View>
          <AppText>
            NAV
          </AppText>

          <AppText variant="title">
            ${fund.nav}
          </AppText>
        </View>


        <View>
          <AppText>
            YTD Return
          </AppText>

          <AppText variant="title">
            {(Number(fund.ytd_return) * 100).toFixed(2)}%
          </AppText>
        </View>


      </View>


      <View style={styles.row}>

        <View>
          <AppText>
            Volatility
          </AppText>

          <AppText>
            {(fund.volatility * 100).toFixed(2)}%
          </AppText>
        </View>


        <View>
          <AppText>
            Drawdown
          </AppText>

          <AppText>
            {(Number(fund.drawdown) * 100).toFixed(2)}%
          </AppText>
        </View>

      </View>


    </ExecutiveSection>
  );
}


const styles = StyleSheet.create({

  row:{
    flexDirection:"row",
    justifyContent:"space-between"
  }

});