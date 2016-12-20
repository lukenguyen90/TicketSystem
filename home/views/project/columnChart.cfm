<cfset request.layout = false />
<cfoutput>
<div id="column"></div>
<cfscript>
    name = '#getLabel("Tickets Status statistic", #SESSION.languageId#)#';
    data = #rc.data#;
</cfscript>
<cfset title = "#getLabel("Tickets statistic for", #SESSION.languageId#)# #rc.projects.projectName# #getLabel("by", #SESSION.languageId#)# #getLabel("Status", #SESSION.languageId#)#">

<script type="text/javascript">
    $('##column').highcharts({
        chart: {
            type: 'column'
        },
        title: {
            text: '#title#'
        },
        xAxis: {
            type: 'category'
        },
        yAxis: {
            title: {
                text: '#getLabel("Total tickets", #SESSION.languageId#)#'
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
            headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
            pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:f}</b> ticket(s)<br/>'
        },

        series: [{
            name: "Brands",
            colorByPoint: true,
            data: [{
                name: "#rc.data[1].name#",
                y: #rc.data[1].val#,
            }, {
                name: "#rc.data[2].name#",
                y: #rc.data[2].val#,
            }
            , {
                name: "#rc.data[4].name#",
                y: #rc.data[4].val#,
            }, {
                name: "#rc.data[5].name#",
                y: #rc.data[5].val#,
            }, {
                name: "#rc.data[6].name#",
                y: #rc.data[6].val#,
            }
            ]
        }]
    });
</script>
</cfoutput>
