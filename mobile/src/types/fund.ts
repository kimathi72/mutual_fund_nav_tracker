export type Fund = {

id:number;

isin:string;

name:string;

currency:string;

latest_nav:number;

nav_date:string;


daily_return:number;

weekly_return:number;

monthly_return:number;

ytd_return:number;


moving_average_7:number;

moving_average_30:number;


volatility_30:number;

drawdown:number;

}