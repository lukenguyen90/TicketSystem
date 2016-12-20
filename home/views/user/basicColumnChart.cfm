<cfset request.layout = false />
<cfoutput>
<div id="column"></div>
<cfif structKeyExists(rc,'gmData')>
    <cfset dateLocal="#serializeJSON(rc.gmData.date)#">
    <cfset hours ="#serializeJSON(rc.gmData.hours)#">
    <cfset resovld ="#serializeJSON(rc.gmData.resovld)#">
    <script type="text/javascript">
        $('##column').highcharts({
            chart: {   
                type: 'column'
            },
            title: {
                text: 'Monthly hours and resovled ticket statistic'
            },
            subtitle: {
                text: '#rc.charTitle#'
            },
            xAxis: {
                categories: #dateLocal#
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Amount'
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
                data: #hours#
    
            }, {
                name: 'Resovld',
                data: #resovld#
    
            }] 
        });
    </script>
<cfelse>
    Nothing to show!
</cfif>
</cfoutput>
