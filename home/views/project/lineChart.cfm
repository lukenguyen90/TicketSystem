<cfset request.layout = false />
<cfoutput>
<div id="monthlyEntry"></div>
<script type="text/javascript">
    $('##monthlyEntry').highcharts({
    chart: {
                type: 'line'
            },
            title: {
                text: '#getLabel("Monthly Average Hours", #SESSION.languageId#)#',
                x: -20 //center
            },
            subtitle: {
                text: '#getLabel("Project", #SESSION.languageId#)#: #rc.data.projectName#',
                x: -20
            },
            xAxis: {
                categories: [<cfset isFirst = ''><cfloop array=#rc.monthlyCate#  index="dVal">#isFirst##dVal#<cfset isFirst = ','></cfloop>]
            },
            yAxis: {
                title: {
                    text: '#getLabel("Hours", #SESSION.languageId#)# (h)'
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '##808080'
                }]
            },
            tooltip: {
                valueSuffix: 'h'
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle',
                borderWidth: 0
            },
            series: [{
                name: '#getLabel("Total hours", #SESSION.languageId#)#',
                data: [<cfset isFirst = ''><cfloop array=#rc.monthlyData#  index="dVal">#isFirst##dVal#<cfset isFirst = ','></cfloop>]
            }]
	});

</script>
</cfoutput>
