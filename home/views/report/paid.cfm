<cfset stChart = {
            chart: {
                renderTo:"container",
                type: 'column'
            },
            title: {
                text: 'Monthly Average Rainfall'
            },
            subtitle: {
                text: 'Source: WorldClimate.com'
            },
            xAxis: {
                categories: [
                    '1',
                    '2',
                    '3',
                    '4',
                    '5'
                ]
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Rainfall (mm)'
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td><td style="padding:0"><b>{point.y:.1f}</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: [{
                name: 'Hour',
                data: [5,12,4,4,2]
    
            }, {
                name: 'Resovld',
                data: [1,2,3,4,2]
    
            }]
        }>

    <div id="container"></div>
    <cfhighchart attributeCollection="#stChart#" createContainer="false">


<cfset stChart = {
        chart: {
            renderTo:"container1",
            plotBackgroundColor: 'null',
            plotBorderWidth: 'null',
            plotShadow: false
        },
        title: {
            text: 'Browser market shares at a specific website, 2010'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    color: 'black',
                    connectorColor: 'black',
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %'
                }
            }
        },
        series: [{
            type: 'pie',
            name: 'Browser share',
            data: [
                ['Time on Bug',   1],
                ['Time on internal issue',       2],
                ['Time on  improvement',    3],
                ['Time on new feature',     2]
            ]
        }]
    }>

    <div id="container1"></div>
    <cfhighchart attributeCollection="#stChart#" createContainer="false">