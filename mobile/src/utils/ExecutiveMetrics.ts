export function calculateOpportunityScore(fund:any){

 const ytd =
   Number(fund.performance?.ytd_return ?? 0);

 const volatility =
   Number(fund.risk?.volatility ?? 0);


 let score = 50;


 if(ytd > 10)
   score += 25;

 else if(ytd > 5)
   score += 15;


 if(volatility < 10)
   score += 15;


 return Math.min(
   Math.round(score),
   100
 );
}



export function generateRecommendation(fund:any){

 const ytd =
 Number(fund.performance?.ytd_return ?? 0);


 if(ytd > 10)
   return "BUY / ACCUMULATE";


 if(ytd > 0)
   return "HOLD";


 return "REVIEW POSITION";

}



export function generateMarketOutlook(fund:any){

 const score =
 calculateOpportunityScore(fund);


 if(score >=80)
   return "Positive";

 if(score >=60)
   return "Neutral";


 return "Cautious";

}