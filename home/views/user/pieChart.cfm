<cfset request.layout = false />
<cfoutput>
<div id="pie_chart"></div>
<cfif structKeyExists(rc,'gdData')>
    <cfif rc.gdData.Bug neq "" AND  rc.gdData.Improvement neq "" AND  rc.gdData.Newfeature neq "" AND rc.gdData.InternalIssue neq "">
        <script type="text/javascript">
            $('##pie_chart').highcharts({
                
                title: {
                    text: 'Spenting time for each work'
                },
                subtitle: {
                    text: '#rc.charTitle#'
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
                        ['Time on Bug',   #rc.gdData.Bug#],
                        ['Time on internal issue',  #rc.gdData.Improvement#],
                        ['Time on  improvement',    #rc.gdData.Newfeature#],
                        ['Time on new feature',     #rc.gdData.InternalIssue#]
                    ]
                }]
            });
        </script>
    </cfif>
<cfelse>
    Nothing to show!
</cfif>
</cfoutput>
