<cfset request.layout = false />
<cfoutput>
<cfset i=1>
<div id="burndownChartSprint"></div>
<script type="text/javascript">
	    $('##burndownChartSprint').highcharts({
	      chart: {
	            type: 'spline'
	        },
	        title: {
	            text: '#rc.lastModule.moduleName#'
	        },
	        subtitle: {
	            text: ''
	        },
	        xAxis: {
	            type: 'datetime',
	            dateTimeLabelFormats: { // don't display the dummy year
	                month: '%b-%Y',
	                year: '%Y'
	            },
	            title: {
	                text: 'Date'
	            }
	        },
	        yAxis: {
	            title: {
	                text: 'Point'
	            },
	            min: 0
	        },
	        tooltip: {
	            headerFormat: '<b>{series.name}</b><br>',
	            pointFormat: '{point.x:%e. %b %Y}: {point.y:.1f} points'
	        },

	        plotOptions: {
	            spline: {
	                marker: {
	                    enabled: true
	                }
	            }
	        },
			series: [{
		            name: "Plan",
		            // Define the data points. All series have a dummy year
		            // of 1970/71 in order to be compared on the same x axis. Note
		            // that in JavaScript, months start at 0 for January, 1 for February etc.
		            data: 	[<cfset isFirst = ''><cfloop array=#rc.sprint[i]#  index="dVal">
		            			#isFirst#[#dVal[1]#,#dVal[2]#]<cfset isFirst = ','>
		            		</cfloop>]    
		            
		        }
		        , {
		            name: "Acture",
		            data: [<cfset isFirst = ''><cfloop array=#rc.rsprint[i]#  index="dVal">
		            			#isFirst#[#dVal[1]#,#dVal[2]#]<cfset isFirst = ','>
		            		</cfloop>] 
		            
		        }]
	});
</script>
</cfoutput>
