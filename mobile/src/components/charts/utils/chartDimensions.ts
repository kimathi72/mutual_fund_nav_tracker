import ExecutiveChartTheme from "../ExecutiveChartTheme";

export interface ChartDimensions{

    width:number;

    height:number;

    paddingTop:number;

    paddingBottom:number;

    paddingLeft:number;

    paddingRight:number;

    innerWidth:number;

    innerHeight:number;

}

export function getChartDimensions(

    width:number,

    height:number

):ChartDimensions{

    const chart=ExecutiveChartTheme.chart;

    const innerWidth=
        width-
        chart.paddingLeft-
        chart.paddingRight;

    const innerHeight=
        height-
        chart.paddingTop-
        chart.paddingBottom;

    return{

        width,

        height,

        paddingTop:chart.paddingTop,

        paddingBottom:chart.paddingBottom,

        paddingLeft:chart.paddingLeft,

        paddingRight:chart.paddingRight,

        innerWidth,

        innerHeight

    };

}