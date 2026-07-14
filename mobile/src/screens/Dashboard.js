import React,{
useEffect,
useState
} from "react";


import {

View,
Text,
ScrollView,
StyleSheet

} from "react-native";


import api from "../api/client";

import FundCard from "../components/FundCard";

export default function Dashboard(){


const [data,setData]=useState(null);

const [error,setError]=useState(null);



useEffect(()=>{


api
.get("/dashboard")

.then(response=>{

setData(response.data);

})

.catch(error=>{

console.log(error);

setError(
"Unable to load dashboard"
);

});


},[]);



if(error)

return (

<Text>
{error}
</Text>

);



if(!data)

return (

<View style={styles.center}>

<Text>
Loading executive dashboard...
</Text>

</View>

);



return (

<ScrollView style={styles.container}>


<Text style={styles.title}>
Executive Dashboard
</Text>



<Text style={styles.date}>
Market Date:
{" "}
{data.summary.report_date}
</Text>
<Text style={styles.section} >
    Briefing 
</Text>
<Text style={styles.briefing}>
    {data.briefing.briefing}
</Text>

<Text style={styles.section}>
Fund Performance
</Text>


{console.log(data.funds)}
{
    
  data.funds?.map(fund => <FundCard key={fund.id} fund={fund} />)
}


</ScrollView>

)


}




const styles=StyleSheet.create({

container:{

padding:20,
backgroundColor:"#f5f7fa"

},


title:{

fontSize:30,
fontWeight:"bold",
marginBottom:10

},


date:{

color:"#666",
marginBottom:20

},
briefing:{

color:"#1b3d0d",
marginBottom:20,
fontSize: 17,
backgroundColor: "aqua",
padding: 10,
borderRadius: 5

},


section:{

fontSize:20,
fontWeight:"bold",
marginBottom:10

},


center:{

flex:1,
justifyContent:"center",
alignItems:"center"

}


});