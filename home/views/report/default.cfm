<cfoutput>
	<cfparam name="URL.pid" default="0">
	<cfparam name="URL.uid" default="0">
	<cfparam name="URL.start" default="#dateFormat(now(),"yyyy-mm-dd")#">
	<cfparam name="URL.end" default="#dateFormat(now(),"yyyy-mm-dd")#">
<cfif rc.prj.recordCount NEQ 0>
	<div class="row clearfix">
		<div class="row col-md-12">
			<!--- <button class="btn btn-sm btn-info pull-right" style="height:26px; line-height: 8px !important; margin-right:10px;" onclick="change();">
				<i class="ace-icon fa fa-search nav-search-icon"></i>
			</button> --->
			<div class="input-daterange input-group pull-right" style="margin-right:10px;">
				<input type="text" class="input form-control" style="height:26px;"<cfif structKeyExists(URL, "start")>value="#URL.start#"</cfif> name="startDay" id="startDay" onchange="change()">
				<span class="input-group-addon" style="height:26px;width:20px;padding: 2px 5px;">
					<i class="fa fa-exchange" ></i>
				</span>

				<input type="text" class="input form-control" style="height:26px;"<cfif structKeyExists(URL, "end")>value="#URL.end#"</cfif> name="endDay" id="endDay" onchange="change()">
			</div>	
			<div class="pull-right" style="margin-right:10px;">	
				<select multiple="multiple" id="user" onchange="change()" data-placeholder="Select assignee...">
					<!--- <option value="0">#getLabel("Select all users", #SESSION.languageId#)#</option> --->
					<cfloop query="rc.users">
						<option value="#rc.users.userID#">#rc.users.firstname# #rc.users.lastname#</option>
					</cfloop>
				</select>
			</div>
			<div class="pull-right" style="margin-right:10px;">	
				<select multiple="multiple" id="type" onchange="change()" data-placeholder="Select status...">
					<!--- <option value="0">#getLabel("Select all users", #SESSION.languageId#)#</option> --->
					<cfloop query="rc.ticketType">
						<option value="#rc.ticketType.ticketTypeID#">#rc.ticketType.typeName#</option>
					</cfloop>
				</select>
			</div>
			<div class="pull-right" style="margin-right:10px;">
				<select multiple="multiple" id="prj" onchange="change()" data-placeholder="Select projects...">
					<!--- <option value="0">#getLabel("Select all projects", #SESSION.languageId#)#</option> --->
					<cfloop query="rc.prj">
						<option value="#rc.prj.projectID#" >#rc.prj.projectName#</option>
					</cfloop>
				</select>
			</div>
		</div>
	</div>
	<br>
	<div class="space"></div>
	<!--- Totol time every user --->
	<div class="row">
		<div class="col-md-12">
			<div class="timeUseTotal totalWorkedTime">
				<b> 
					<span id="TotalTimeWorked">
						#int(rc.totalTime/60)#h #(rc.totalTime mod 60)#'	
					</span>
	            </b> Total Time Worked
			</div>
		</div>
		<!--- Close div 12 colum --->
	</div>
	<!--- CLose row 12 --->
	<div class="space"></div>

	<div class="row">
		<div class="col-md-7">
			<cfset maxMinutes = rc.listTimeTicketUser.minutes[1] gt 600 ? rc.listTimeTicketUser.minutes[1] : 600 >
			<cfloop query="#rc.listTimeTicketUser#">
				<cfset logtime = rc.listTimeTicketUser.minutes eq ''?0:rc.listTimeTicketUser.minutes>
				<!--- <h3>Time use</h3> --->
				<b> 
					<span id="TotalTimeWorked">
						#int(logtime/60)# h#(logtime mod 60)#'
					</span>
		        </b>
				
				#rc.listTimeTicketUser.username# 
				<div id="divbar" class="progress progress-mini" title="Logs: #int(logtime/60)#h #(logtime mod 60)#'">
			        <div style="width: #logtime/maxMinutes*100#%;" class="progress-bar progress-bar-green"></div>
			    </div>
			</cfloop>
		</div>
		<!--- Total time for every project --->
		<div class="col-md-5">
			<cfset maxChart = rc.totalTimeProject.minutes[1] gt 600 ? rc.totalTimeProject.minutes[1]:600 >
			<cfloop query="#rc.totalTimeProject#">
				<cfset logtime =rc.totalTimeProject.minutes == ""?0 :rc.totalTimeProject.minutes>
				<b> 
					<span id="TotalTimeWorked">
						#int(logtime/60)# h#(logtime mod 60)#
					</span>
		        </b>
				
				<span class="pull-right"><strong>#rc.totalTimeProject.projectName#</strong></span>
				<div id="divbar" class="progress progress-mini" title="Total time project: #int(logtime/60)# h#(logtime mod 60)# ">
			            <div style="width: #logtime/maxChart*100#%;" class="progress-bar progress-bar-purple"></div>
			    </div>
			</cfloop>
		</div>
		<!--- Close row col-md-6 --->
	</div>
	<!--- CLose row --->
	<div class="space"></div>

	<div class="space"></div> 


	<!--- end total time --->
	<div class="row clearfix">
		<div class="row col-md-12">
			<!--- dynamic event time sheet --->
			<h3 class="header smaller lighter green project-head" style="margin-left:20px;cursor:pointer" data-id=''>
                <i class="fa fa-caret-right" id=''></i> Time sheet detail : 
                    <a href=""></a>
                                <!--- <cfset totallogtime = item.hours*60+item.minute> --->
            </h3>
                            <!--- Scall event --->
			<div id="sample-table-2_wrapper" class="dataTables_wrapper form-inline no-footer">
				<table class="table table-striped table-bordered table-hover dataTable no-footer" id="sample-table-2" role="grid" aria-describedby="sample-table-2_info">
					<thead>
						<tr role="row">
							<th style="width:100px;">#getLabel("Date", #SESSION.languageId#)#</th>
							<th style="width:110px;">#getLabel("User Name", #SESSION.languageId#)#</th>
							<th>#getLabel("Description", #SESSION.languageId#)#</th>
							<th class="col-sm-1">Time</th>
						</tr>
					</thead>

					<tbody id="body">
						 <cfloop query="rc.data">
						 	<cfswitch expression="#rc.data.ticketTypeID#">
						 		<cfcase value="1">
						 			<cfset dicon = '<i class="fa fa-bug red" title="Bug"></i>'>
						 		</cfcase>
						 		<cfcase value="2">
						 			<cfset dicon = '<i class="fa fa-level-up green" title="Improvement"></i>'>
						 		</cfcase>
						 		<cfcase value="3">
						 			<cfset dicon = '<i class="fa fa-plus-square blue" title="New feature"></i>'>
						 		</cfcase>
						 		<cfcase value="4">
						 			<cfset dicon = '<i class="fa fa-search yellow" title="Internal Issue"></i>'>
						 		</cfcase>
						 		<cfdefaultcase>
						 			<cfset dicon = '<i class="fa fa-at"None></i>'>
						 		</cfdefaultcase>
						 	</cfswitch>
                            <tr>
                                <th style="font-weight:normal;">#dateFormat(rc.data.entryDate,"yyyy-mm-dd")#</th>
                                <th style="font-weight:normal;">#rc.data.firstname# #rc.data.lastname#</th>
                                <th style="font-weight:normal;">#dicon# <a class="green" href="/index.cfm/ticket?project=#rc.data.pcode#&id=#rc.data.code#" title="#rc.data.title#">#rc.data.code#</a> #rc.data.description#</th>
                                <cfset logtime = rc.data.hours*60+(rc.data.minute eq ''?0:rc.data.minute)>
                                <th style="font-weight:normal;">#int(logtime/60)#h#(logtime mod 60)#'</th>
                            </tr>
                        </cfloop>
					</tbody>
				</table>
				<table class="table table-striped no-footer" aria-describedby="sample-table-2_info">
					<thead>
						<tr>
							<!--- <th style="background:##6fb3e0;"> </th>
							<th style="background:##6fb3e0;"> </th>
							<th style="background:##6fb3e0;"> </th>
							<th style="background:##6fb3e0;"> </th> --->
							<th class="col-sm-11" style="background:##6fb3e0; color:black;">#getLabel("Total", #SESSION.languageId#)#</th>
							<th class="col-sm-1" style="background:##ed9c28; color:black;" id="sh">#int(rc.sum/60)#h#int(rc.sum mod 60)#'</th>
						</tr>
					</thead>
				</table>
			</div>
		</div>
	</div>
<cfelse>
	#getLabel("There are nothing to show!", #SESSION.languageId#)#
</cfif>

<cfif structKeyExists(URL,"uid")>
	<cfset lUser = listToArray(URL.uid,",")>
	<cfloop array = #lUser# index="lu">
		<script type="text/javascript">
			$("##user").find("option[value='#lu#']").attr("selected","selected");
		</script>
	</cfloop>
</cfif>
<cfif structKeyExists(URL,"tid")>
	<cfset lType = listToArray(URL.tid,",")>
	<cfloop array = #lType# index="lt">
		<script type="text/javascript">
			$("##type").find("option[value='#lt#']").attr("selected","selected");
		</script>
	</cfloop>
</cfif>
<cfif structKeyExists(URL,"pid")>
	<cfset lProject = listToArray(URL.pid,",")>
	<cfloop array = #lProject# index="lp">
		<script type="text/javascript">
			$("##prj").find("option[value='#lp#']").attr("selected","selected");
		</script>
	</cfloop>
</cfif>

</cfoutput>
<script type="text/javascript">
	$(document).ready(function(){
		$('#user').chosen({allow_single_deselect:true}); 
		$('#type').chosen({allow_single_deselect:true}); 
		$('#prj').chosen({allow_single_deselect:true}); 

		$("#startDay").datepicker({
			format: 'yyyy/mm/dd',
			autoclose: true

		})
		$("#endDay").datepicker({
			format: 'yyyy/mm/dd',
			autoclose: true
		})
    });

	function change()
	{
    	url="";
		url+=$("#prj").val() == null ? "": (url==""? '?pid='+$("#prj").val() : '&pid='+$("#prj").val() );
		url+=$("#user").val() == null ? "": (url==""? '?uid='+$("#user").val() : '&uid='+$("#user").val() );
		url+=$("#type").val() == null ? "": (url==""? '?tid='+$("#type").val() : '&tid='+$("#type").val() );
		if($("#startDay").val() != "" && $("#endDay").val() != ""){
			url+=$("#startDay").val() == ""? "": (url=="" ? '?start='+$("#startDay").val() : '&start='+$("#startDay").val() );
			url+=$("#endDay").val() == ""? "": (url=="" ? '?end='+$("#endDay").val() : '&end='+$("#endDay").val() );

		}
		var baseURL = "/index.cfm/report"+url;

		// if(start == "" || end == ""){
		// 	<cfoutput>
		// 	var baseURL = "#getContextRoot()#/index.cfm/report?pid="+pid+"&uid="+uid;
		// 	</cfoutput>
		// }
		// else{
		// 	<cfoutput>
		// 	var baseURL = "#getContextRoot()#/index.cfm/report?pid="+pid+"&uid="+uid+"&start="+start+"&end="+end;
		// 	</cfoutput>
		// }
		
		window.location = baseURL;
	}

</script>
								