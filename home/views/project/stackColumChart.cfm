<cfset request.layout = false />
<div id="stack_chart"></div>
<cfset title = '#getLabel("Tickets statistic for", #SESSION.languageId#)# #rc.projects.projectName# #getLabel("by", #SESSION.languageId#)# #getLabel("Type", #SESSION.languageId#)#'>
<cfset typeTicket="#serializeJSON(rc.typeTicket)#">
<cfset localdata ="#serializeJSON(rc.data)#">
<cfoutput>
<script type="text/javascript">
 $('##stack_chart').highcharts({
        chart: {
            type: 'column'
        },
        title: {
            text: '#title#'
        },
        xAxis: {
            categories: #typeTicket#
        },
        yAxis: {
            min: 0,
            title: {
                text: '#getLabel("Total tickets", #SESSION.languageId#)#'
            },
            stackLabels: {
                enabled: true,
                style: {
                    fontWeight: 'bold',
                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                }
            }
        },
        legend: {
            align: 'right',
            x: -30,
            verticalAlign: 'top',
            y: 25,
            floating: true,
            backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
            borderColor: '##CCC',
            borderWidth: 1,
            shadow: false
        },
        tooltip: {
            formatter: function () {
                return '<b>' + this.x + '</b><br/>' +
                    this.series.name + ': ' + this.y + '<br/>' +
                    'Total: ' + this.point.stackTotal;
            }
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                dataLabels: {
                    enabled: true,
                    color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
                    style: {
                        textShadow: '0 0 3px white',
                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                    }
                }
            }
        },
        series: #localdata#
    });
</script>
</cfoutput>