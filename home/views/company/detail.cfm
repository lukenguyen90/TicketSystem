<!--- <cfdump eval = rc abort> --->
<style type="text/css">
	.over{
	  float:right;
	  background-color: red;
	  color: white;
	}
	.mousechange:hover {
        cursor:pointer;
    }

</style>
<cfoutput>
<cfparam name="URL.id" default="0">
	<!--- <div class="page-content-area"> --->
<div class="page-header">
	<h1>
		#getLabel("Company", #SESSION.languageId#)#
		
		<small>
			<i class="ace-icon fa fa-angle-double-right"></i>
			<a href="/index.cfm/company/">#getLabel("overview", #SESSION.languageId#)# &amp; #getLabel("stats", #SESSION.languageId#)#</a>
			<i class="ace-icon fa fa-angle-double-right"></i>
			#getLabel("details", #SESSION.languageId#)#
		</small>
		
		<div class="col-md-4" style="float: right; margin-right:10px;">
			<cfif SESSION.userType eq 3>
				<div class="col-md-4 pull-right">
					<button class="btn btn-sm btn-info" onclick="addCompany();">
						<i class="menu-icon fa fa-home"><span id="aProject" style="font-family: 'Open Sans';"> #getLabel("New company", #SESSION.languageId#)#</span></i>
					</button>
				</div>	
			</cfif>
			<div class="col-md-8 pull-right">	
				<form action="">
						<select id="scompany" class="form-control" onchange="changeCompany();" style="height:34px; width: 200px;">
							<cfloop query="rc.company">
								<option value="#rc.company.companyID#" <cfif rc.id EQ rc.company.companyID>selected="SELECTED"</cfif>>#rc.company.companyName#</option>
							</cfloop>
						</select>	
				</form>	
			</div>
								
		</div>
	</h1>
</div><!-- /.page-header -->
<div class="row">
	<div class="row col-xs-12">
		<div class="col-sm-8">
			<h4 class="smaller lighter green">
				<i class="ace-icon fa fa-list"></i>
                	#rc.data.companyName#
                	<div class="col-md-8 pull-right">
                <select id="syear" multiple="multiple" class="pull-right" onchange="change();">
					<cfloop query="rc.dyears">
						<option value="#rc.dyears.y#">#rc.dyears.y#</option>
					</cfloop>
				</select>	
				<select id="ttype" name="ttype" multiple="multiple" class="pull-right" onchange="change();" style="margin-right: 10px;">
					<cfloop query="rc.type">
						<option value="#rc.type.ticketTypeID#">#rc.type.typeName#</option>
					</cfloop>
				</select></div>
			</h4>
		</div>
	</div>
	<div style="clear:right;"></div>
	
	<div class="row col-md-12">
		<div class="col-sm-8 col-md-8">					
			<div id="ticket-table-2_wrapper" class="dataTables_wrapper form-inline no-footer">			
				<table class="table table-striped table-bordered table-hover dataTable no-footer" id="ticket-table-2" role="grid" aria-describedby="ticket-table-2_info">
					<thead>
						<tr role="row">
							<th>#getLabel("Time", #SESSION.languageId#)#</th>
							<th>#getLabel("Tickets", #SESSION.languageId#)#</th>
							<th>#getLabel("Hours", #SESSION.languageId#)#</th>
							<th>#getLabel("Paid status", #SESSION.languageId#)#</th>
						</tr>
					</thead>
					<tbody id="body">
						<cfloop array = #rc.rs# index="item">
							<tr>
								<td>#item.month#</td>
								<td>
									
									<cfloop array=#item.ticket.detail# index="subticket">
										<a href="/index.cfm/project/?id=#subticket.projectID#">#subticket.projectName#</a><div class="pull-right">#subticket.ticket#</div><br>
									</cfloop>
									<div style="border-bottom: 1px solid ##6fb3e0 "></div>
									<div style="color:##d15b47">Sum tickets <div class="pull-right">#item.ticket.sum#</div></div>
									
								</td>
								<td>
									
									<cfloop array=#item.hours.detail# index="subhour">
										<a href="/index.cfm/project/?id=#subhour.projectID#">#subhour.projectName#</a><cfif subhour.hour GT 0><div class="pull-right">#subhour.hour#</div><cfelse><div class="pull-right">0</div></cfif><br>
									</cfloop>
									<div style="border-bottom: 1px solid ##6fb3e0 "></div>
									<div style="color:##d15b47">Sum hours <div class="pull-right">#item.hours.sum#</div></div>
									
								</td>
								<td id="#dateFormat(#item.month#,"m")##dateFormat(#item.month#,"yyyy")#">	
									<cfset dpid = "">	
									<cfset dqpid = "">					
									<cfloop array=#item.ticket.detail# index="subticket">
										<cfset dpaid = 0>
										<cfset dpid = dpid&subticket.projectID&",">
										<a href="/index.cfm/project/?id=#subticket.projectID#">#subticket.projectName#</a> &nbsp; 
										<cfloop array=#item.paid# index="subpaid">
											<cfif subpaid.projectID EQ subticket.projectID>
												<cfset dpaid = 1>
												<cfbreak>	
											<cfelse>
												<cfset dqpid = dqpid&subticket.projectID&",">
											</cfif>
										</cfloop>
										<span id="dq#subticket.projectID##dateFormat(#item.month#,"m")##dateFormat(#item.month#,"yyyy")#">
											<cfif dpaid EQ 1>
												<a class="green"><i class="ace-icon fa fa-check bigger-110 icon-on-right"></i></a>
											<cfelse>
												<a class="danger mousechange" title="Click to pay" onclick="paidProject(#subticket.projectID#, #dateFormat(#item.month#,"m")#, #dateFormat(#item.month#,"yyyy")#)"><i class="ace-icon fa fa-shopping-cart  bigger-110 icon-on-right"></i></a>
												<!--- <span  class="label label-primary mousechange" onclick="paidProject(#subticket.projectID#, #item.index#)">Paid</span> --->
											</cfif>
										</span>
										<br>										
									</cfloop>
									<cfif dqpid NEQ "">
										<cfset dpid = dqpid&"0">
									<cfelse>
										<cfset dpid = dpid&"0">
									</cfif>
									<cfif arrayLen(item.ticket.detail) EQ arrayLen(item.paid)>
										<span id='b#dateFormat(#item.month#,"m")##dateFormat(#item.month#,"yyyy")#' class="label label-success">Paid</span>
									<cfelse>
										<span id='b#dateFormat(#item.month#,"m")##dateFormat(#item.month#,"yyyy")#' class="label label-primary mousechange" onclick="paidMonth('#dpid#', #dateFormat(#item.month#,"m")#, #dateFormat(#item.month#,"yyyy")#)">Pay for month</span>
									</cfif>
									
								</td>
							</tr>
						</cfloop>						
					</tbody>
				</table>
			</div>
			<br>
		</div>
		<div class="col-sm-4 col-md-4">
		    <div id="addPrj" class="alert alert-block" style="background: ##fee188;">
				<p>
					<strong>
						<!--- <i class="ace-icon fa fa-check"></i> --->
						#getLabel("Add available project to this company", #SESSION.languageId#)#
					</strong>
					<hr>
					<div id="dprj" class="tags" style="background-color: ##fee188; border: none; width:100%;">
						<cfloop query="rc.project">
							<cfif rc.project.companyID == id>
								<span id="p#rc.project.projectID#" class="tag">#rc.project.projectName#<button type="button" class="close" onclick='removePrj(#rc.project.projectID#)'>x</button></span>								
							</cfif>
						</cfloop>
					</div>
					<select id="prj" class="form-control">
						<cfloop query="rc.project">
							<cfif rc.project.companyID != id>
								<option id="o#rc.project.projectID#" value="#rc.project.projectID#">#rc.project.projectName#</option>		
							</cfif>
						</cfloop>
						<!--- <cfloop query="rc.users">
							<option id="o#rc.users.userID#" value="#rc.users.userID#">#rc.users.firstname# #rc.users.lastname#</option>
						</cfloop> --->
					</select>
				</p>

				<p>
					<button id="bPrj" class="btn btn-sm btn-danger" onclick="pAdd();">#getLabel("Add Project", #SESSION.languageId#)#</button>
					<!--- <button class="btn btn-sm" onClick="mclose()">Close</button> --->
				</p>
			</div>

			</br>
		    <!---Add user to project--->
			<div id="addUser" class="alert alert-block alert-success">
				<p>
					<strong>
						<!--- <i class="ace-icon fa fa-check"></i> --->
						#getLabel("Add user to this company", #SESSION.languageId#)#
					</strong>
					<hr>
					<div id="dUser" class="tags" style="background-color: ##dff0d8; border: none; width:100%;">		<cfloop query="rc.user">
							<cfif rc.user.companyID == id>
								<cfset name = rc.user.firstname & " " & rc.user.lastname>
								<span id="s#rc.user.userID#" class="tag">#rc.user.firstname# #rc.user.lastname#<button type="button" class="close" onclick='removeUser(#rc.user.userID#,"#name#")'>x</button></span>
							</cfif>
						</cfloop>
						
					</div>
					
					<select id="user" class="form-control">						
						<cfloop query="rc.user">
							<cfif rc.user.companyID != id>
								<option id="o#rc.user.userID#" value="#rc.user.userID#">#rc.user.firstname# #rc.user.lastname#</option>
							</cfif>
						</cfloop>						
					</select>	
					
				</p>

				<p>
					<button id="bUser" class="btn btn-sm btn-info" onclick="dAdd();">#getLabel("Add User", #SESSION.languageId#)#</button>
					<!--- <button class="btn btn-sm" onClick="dclose()">#getLabel("Close", #SESSION.languageId#)#</button> --->
				</p>
			</div>
		</div>
	</div><!-- /.col -->
</div><!-- /.row -->

<script type="text/javascript">
	var id=#rc.id#;
</script>
<script>
	var url = "";
	$("##ttype").multipleSelect();
	$("##syear").multipleSelect();
	function changeCompany()
	{
		var projectID = $("##scompany").val();
		var baseURL = "#getContextRoot()#/index.cfm/company/detail?id=" + projectID + "&year=2014";
		window.location = baseURL;
	}
	function getData()
	{
		$.ajax({
		        type: "GET",
		        url: "/index.cfm/company.load"+url,	       
		        success: function (data) {
		        	$("##body").empty();
		        	$("##body").append(data.htmlstring);
		        }
		});
	}
	function change()
	{
		url="";
		url+=$("##scompany").val() == null ? "": (url==""? '?id='+$("##scompany").val() : '&id='+$("##scompany").val() );
		url+=$("##syear").val() == null ? "": (url==""? '?year='+$("##syear").val() : '&year='+$("##syear").val() );
		url+=$("##ttype").val() == null ? "": (url==""? '?type='+$("##ttype").val() : '&type='+$("##ttype").val() );
		window.history.pushState('Filter', 'Filter', '/index.cfm/company/detail'+url );
		getData();
	}

	function pAdd()
	{
		$.ajax({
	            type: "POST",
	            url: "/index.cfm/company.addProject",
	            data: {
	            	companyID : id,
	            	projectID : $("##prj").val()
	            },
	            success: function( data ) {
	            	location.reload();
	            }
	        });

	}

	function removePrj(pid)
	{
		$.ajax({
	            type: "POST",
	            url: "/index.cfm/company.removePrj",
	            data: {
	            	companyID : id,
	            	projectID : pid
	            },
	            success: function( data ) {	
					location.reload();
	            }
	        });
	}
	function dAdd()
	{
		var userID = $("##user").val();
		var name = $("##o"+userID.toString()).text();
		$("##bUser").attr({
			'disabled':'disabled'
		})
		$.ajax({
	            type: "POST",
	            url: "/index.cfm/company.addUser",
	            data: {
	            	companyID : id,
	            	userID : userID
	            },
	            success: function( data ) {
					$("##o"+userID.toString()).remove();
					//var t = $('<span id="s'+userID+'" class="tag">'+name+'<button type="button" onclick="removeUser('+userID+',\"'+name.toString()+'\")">X</button></span>');

					var t = $('<span\/>').attr({
						'class': 'tag',
						'id': 's' + userID,
					}).text(name).append(
						$('<button\/>').attr({
							'type': 'button',
							'class': 'close',
							'onClick': 'removeUser(' + userID + ',\"' + name + '\")'
						}).text('x')
					);

					// alert(t);
					$("##dUser").append(t);

					$("##bUser").removeAttr("disabled");
	            }
	        });
	}

	function removeUser(uid, name)
	{		
		$.ajax({
	            type: "POST",
	            url: "/index.cfm/company.removeUser",
	            data: {
	            	projectID : id,
	            	userID : uid
	            },
	            success: function( data ) {
	            	
					$("##s"+uid.toString()).remove();
					$("##user").append('<option id="o'+uid+'" value="'+uid+'">'+name.toString()+'</option>');
	            }
	        });
	}

	function paidMonth(dpid, dmonth, dyear)
	{
		if(confirm("Do you want to paid for this month?"))
    	{
			$.ajax({
	            type: "POST",
	            url: "/index.cfm/company.paidMonth",
	            data: {
	            	companyID : id,
	            	pmonth : dmonth,
	            	pyear : dyear,
	            	pid : dpid
	            },
	            success: function( data ) {  
	            	location.reload();
	            }
	        });
		}
	}

	function paidProject(pid, dmonth, dyear)
	{
		if(confirm("Do you want to paid for this project?"))
    	{
			$.ajax({
	            type: "POST",
	            url: "/index.cfm/company.paidProject",
	            data: {
	            	companyID : id,
	            	projectID : pid,
	            	pmonth : dmonth,
	            	pyear : dyear
	            },
	            success: function( data ) {
	            	$("##dq"+pid+dmonth+dyear).html("");
					$("##dq"+pid+dmonth+dyear).append('<a class="green"><i class="ace-icon fa fa-check bigger-110 icon-on-right"></i></a>');
					var d = $('##'+dmonth+dyear+' .fa-shopping-cart').length;
					if (d == 0)
					{
						$('##b'+dmonth+dyear).removeClass("label-primary");
						$('##b'+dmonth+dyear).removeClass("mousechange");
						$('##b'+dmonth+dyear).addClass("label-success");
						$('##b'+dmonth+dyear).html("Paid");						
					}
	            }
	        });
		}
	}
</script>
</cfoutput>
