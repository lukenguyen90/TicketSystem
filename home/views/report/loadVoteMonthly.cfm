<cfoutput>
	<cfset request.layout = false>
<div class="container-fluid">
		<div class="row">
			<div class="col-md-10">
				<div class="space"></div>
				<div class="space"></div>
			<cfloop query="rc.resultVote">
	            <cfset maxCountVote = rc.resultVote.totalVote[1] gt 50? rc.resultVote.totalVote[1]:50 >
	            <!--- <div class="col-md-6 col-sm-12"> --->
	                <cfset totalVote = rc.resultVote.totalVote == ""?0:rc.resultVote.totalVote>
	                <b> 
	                    <span >
	                        <strong style="font-size: 20px;">#totalVote#</strong>
	                    </span>
	                </b>
	                <span ><strong> <b>-</b> #rc.resultVote.username#</strong></span>
	                <div id="divbar" class="progress progress-mini" title="Total votes 's #rc.resultVote.username#: #totalVote#">
	                    <div style="width: #totalVote/maxCountVote*100#%;" class="progress-bar progress-bar-green"></div>
	                </div>
	            <!--- </div> --->
        	</cfloop>

			</div>
			<!--- close col-md-10 --->
		</div>
</div>
</cfoutput>