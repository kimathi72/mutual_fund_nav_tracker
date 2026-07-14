import { Stack } from "expo-router";


export default function Layout(){

return (

<Stack>

<Stack.Screen
name="index"
options={{
title:"Executive Dashboard"
}}
/>


<Stack.Screen
name="fund/[id]"
options={{
title:"Fund Details"
}}
/>


</Stack>

)

}