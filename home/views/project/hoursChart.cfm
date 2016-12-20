<cfset request.layout = false />
<div id="hour_chart"></div>
<cfoutput>
<cfset title = "#getLabel("Hours statistic for", #SESSION.languageId#)# #rc.projects.projectName# #getLabel("by", #SESSION.languageId#)# #getLabel("Assignee", #SESSION.languageId#)#">
<cfset name = 'Hours statistic'>
<cfset localdata="#serializeJSON(rc.data)#">
<script type="text/javascript">
    $('##hour_chart').highcharts({
        chart: {
            type: 'column',
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            plotShadow: false
        },
        title: {
            text: '#title#'
        },
        xAxis: {
            type: 'category'
        },
        yAxis: {
            title: {
                text: '#getLabel("Total hours", #SESSION.languageId#)#'
            }

        },
        legend: {
            enabled: false
        },
        plotOptions: {
            series: {
                borderWidth: 0,
                dataLabels: {
                    enabled: true,
                    format: '{point.y:f}',
                    style: {
                        textShadow: '0 0 3px white',
                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                    }
                }
            }
        },

        tooltip: {
            headerFormat: '<span style="font-size:11px; margin-bottom: 100px" >{series.name}</span><br>',
            pointFormat: '<span style="color:{point.color}; margin-bottom: 100px">{point.name}</span>: <b>{point.y:f}</b> hours<br/>'
        },

        series: [{
            name: "Brands",
            colorByPoint: true,
            data: #localdata#
        }]
    });
</script>
</cfoutput>