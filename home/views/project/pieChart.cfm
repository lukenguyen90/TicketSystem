<cfset request.layout = false />
<cfoutput>
<div id="pie_chart"></div>
<cfset title = '#getLabel("Hours spent for", #SESSION.languageId#)# #rc.data.projectName#'>
<cfset RemainTime = rc.estimateTime.e - rc.timeEntries.r>
<cfset EntryTime = rc.timeEntries.r>
<script type="text/javascript">
		$('##pie_chart').highcharts({
			  chart: {
            type: 'pie',
            options3d: {
                enabled: true,
                alpha: 45,
                beta: 0
            }
        },
        title: {
            text: '#title#'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                depth: 35,
                dataLabels: {
                    enabled: true,
                    format: '{point.name}',
                    style: {
                        textShadow: '0 0 3px white',
                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                    }
                }
            }
        },
        series: [{
            type: 'pie',
            name: 'Progress',
            data: [
                ['Remain time', #RemainTime#],
                ['Entries Time', #EntryTime#],
            ]
        }]
});			
</script>
</cfoutput>
