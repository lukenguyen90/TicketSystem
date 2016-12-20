
<cfoutput>
<cfparam name="URL.date" default="#dateFormat(now(), 'yyyy-mm-dd')#">
<div class="space"></div>
<div class="row clearfix">
    <div class="col-xs-12 col-lg-12" style="border-bottom:2px ##428bca solid;">
        <h1 class="blue" >#getLabel("Monthly Performance", #SESSION.languageId#)#
        	<small class="month-name">#dateFormat(URL.date,'yyyy MMMM')#</small>
	       <!---  <div class="pull-right" style="margin-top: -5px;">
				<button class="label label-lg label-purple arrowed" onClick='changeMonth("prev")'>Prev</button>
				<button id="btn-current-month" class="label label-lg label-info" onClick='changeMonth("current")'>#getLabel("Current Month", #SESSION.languageId#)#</button>
				<button id="btn-next-month" class="label label-lg label-success arrowed-right" onClick='changeMonth("next")'>#getLabel("Next", #SESSION.languageId#)#</button>
	        </div> --->
        </h1>
    </div>
</div>
<div class="space"></div>
<div class="space"></div>
    <div class="container-fluid">
	<div class="row">
		<div class="col-md-12">
			<div class="space"></div>
			<div class="space"></div>
			<form class="form" role="form" action="/index.cfm/report/addCheckBox" method="post">
				<table class="table table-hover table-striped">
					<thead>
						<tr>
							<th>Votes</th>
							<th>Name Developer</th>
							<th>Position</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="rc.userList">
							
							<tr class="">
								<td>
									<cfif rc.filterVoteMonthly.totalVoted gte 1>
										<input type="checkbox" name="cbSurvey" id="cbSurvey" disabled value="#rc.userList.userID#">
										<cfelse>
											<input type="checkbox" name="cbSurvey" id="cbSurvey" value="#rc.userList.userID#">
									</cfif>
								</td>
								<td>#rc.userList.username#</td>	
								<td>#rc.userList.userType#</td>
							</tr>
						</cfloop>

					</tbody>
				</table>
				<cfif rc.filterVoteMonthly.totalVoted gte 1 >
					<button type="submit" class="btn btn-primary btn-default" disabled >Post Survey</button>
					<cfelse>
						<button type="submit" class="btn btn-primary btn-default" id="postVote" value="submit">Post Survey</button>
				</cfif>
			</form>
		</div>
		<!--- close col-md-12 --->
	</div>
</div>
</cfoutput>
<script type="text/javascript">
	$(document).ready(function () {
	   $("input[name='cbSurvey']").change(function () {
	      var maxAllowed = 3;
	      var cnt = $("input[name='cbSurvey']:checked").length;
	      if (cnt > maxAllowed) 
	      {
	         $(this).prop("checked", "");
	         alert('You only maximum ' + maxAllowed + ' votes, thanks!');
	     }
	  });
	});

	function checkForm(form){
		if (!form.cbSurvey.checked) {

			alert('You did not choose any of the checkboxes!');
			// form.cbSurvey.focus();
			return false;
		}else if (!confirm('Are you sure with voted ?')) {
			return true;
		};
	}
	
</script>