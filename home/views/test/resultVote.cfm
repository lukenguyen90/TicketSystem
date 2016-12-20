
<cfoutput>
<cfparam name="URL.date" default="#dateFormat(now(), 'yyyy-mm-dd')#">
<div class="space"></div>
<div class="row clearfix">
    <div class="col-xs-12 col-lg-12" style="border-bottom:2px ##428bca solid;">
        <h1 class="blue" >#getLabel("Total Votes", #SESSION.languageId#)#
        	<small class="month-name">#dateFormat(URL.date,'yyyy MMMM')#</small>
	        <div class="pull-right" style="margin-top: -5px;">
				<button class="label label-lg label-purple arrowed" onClick='changeMonth("prev")'>Prev</button>
				<button id="btn-current-month" class="label label-lg label-info" onClick='changeMonth("current")'>#getLabel("Current Month", #SESSION.languageId#)#</button>
				<button id="btn-next-month" class="label label-lg label-success arrowed-right" onClick='changeMonth("next")'>#getLabel("Next", #SESSION.languageId#)#</button>
	        </div>
        </h1>
    </div>
</div>
<div class="space"></div>
<div class="space"></div>
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
<param name="selected.userID" default="0">
<script type="text/javascript">
	// var userID = #selected.userID#;
	function checkBox()
		{
			var userID = $('#checkID').val();

			$.ajax({
				type: "POST",
				url: "/index.cfm/home:test.default",
				data:{
					userID: userID,
				},
				success: function( data ) {
	            	location.reload();
	            }	
			});
		}
</script>