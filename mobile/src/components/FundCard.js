import {
View,
Text,
Pressable,
StyleSheet
} from "react-native";


import {
router
} from "expo-router";


export default function FundCard({ fund }){


return (

<Pressable

onPress={()=>router.push(`/fund/${fund.id}`)}

style={styles.card}

>


<View>


<Text style={styles.title}>

{fund.name}

</Text>



<Text>

NAV:

{fund.latest_nav}

</Text>



<Text>

YTD:

{fund.ytd_return}%

</Text>



<Text>

Volatility:

{fund.volatility_30}%

</Text>



</View>


</Pressable>

)

}



const styles=StyleSheet.create({

card:{
padding:20,
margin:10,
borderRadius:12,
backgroundColor:"#eee"
},


title:{
fontSize:18,
fontWeight:"bold"
}

})