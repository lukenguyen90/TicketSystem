<link rel="stylesheet" href="/ACEAdmin/assets/css/fullcalendar.css" />
<style type="text/css">

</style>
<cfoutput>
<cfscript>
	var listColor=arrayNew(1);
	listColor[1]="success";
	listColor[2]="danger";
	listColor[3]="purple";
	listColor[4]="yellow";
	listColor[5]="pink";
	listColor[6]="info";
	listColor[7]="grey";
	var listDate={};
</cfscript>
	<div class="page-header">
		<div class="row">
			<div class="col-md-6">
				<h1>
					#getLabel("Timeline", #SESSION.languageId#)#
					<small>
						<i class="ace-icon fa fa-angle-double-right"></i>
						<cfif structKeyExists(rc,"projectName")>
							#rc.projectName#
						<cfelse>
							#getLabel("All Projects", #SESSION.languageId#)#
						</cfif>
					</small>
				</h1>
			</div>
			<div class="col-md-6 pull-right">
				<cfif structKeyExists(rc,"users")>
				<select class="pull-right inline mainInput"  id="as" name="as" onchange='selectChange()'>
					<option value="" >#getLabel("Select Assignee", #SESSION.languageId#)#</option>
					<cfloop query=#rc.users# >
						<option value="#rc.users.userID#" >#rc.users.firstname# #rc.users.lastname#</option>
					</cfloop>
				</select>
				</cfif>
				<cfif structKeyExists(rc,"projects")>
				<select class="pull-right inline mainInput"  id="pj" name="pj" onchange='selectChange()'>
					<option value="" >#getLabel("Select Project", #SESSION.languageId#)#</option>
					<cfloop query=#rc.projects# >
						<option value="#rc.projects.code#" >#rc.projects.projectName#</option>
					</cfloop>
				</select>
				</cfif>
			</div>
		</div>
	</div><!-- /.page-header -->

	<div class="row">
		<div class="col-xs-12">
			<!-- PAGE CONTENT BEGINS -->
			<div class="row">
				<div class="col-sm-12">
					<div class="space"></div>

					<div id="calendar"></div>

				</div>

				<!--- <div class="col-sm-3">
					<div class="widget-box transparent">
						<div class="widget-header">
							<h4>List Users</h4>
						</div>

						<div class="widget-body">
							<div class="widget-main no-padding">
								<div id="external-events">
									<cfloop query=#rc.users#>
										<div class="external-event label-#listColor[rc.users.userID]#" data-class="label-#listColor[rc.users.userID]#">
											<i class="ace-icon fa fa-arrows"></i>
											#rc.users.firstname#-#rc.users.lastname#
										</div>
										
									</cfloop>
								</div>
							</div>
						</div>
					</div>
				</div> --->
			</div>

			<!-- PAGE CONTENT ENDS -->
		</div><!-- /.col -->
	</div><!-- /.row -->
	<cfif structKeyExists(URL,"pj")>
		<script type="text/javascript">
			$("##pj").find("option[value='#URL.pj#']").attr("selected","selected");
		</script>
	</cfif>
	<cfif structKeyExists(URL,"as")>
		<script type="text/javascript">
			$("##as").find("option[value='#URL.as#']").attr("selected","selected");
		</script>
	</cfif>
</cfoutput>
		<!-- page specific plugin scripts -->
		<script src="/ACEAdmin/assets/js/jquery-ui.custom.min.js"></script>
		<script src="/ACEAdmin/assets/js/jquery.ui.touch-punch.min.js"></script>
		<script src="/ACEAdmin/assets/js/fullcalendar.min.js"></script>

		<!-- inline scripts related to this page -->
		<script type="text/javascript">
			jQuery(function($) {

/* initialize the external events
	-----------------------------------------------------------------*/

	$('#external-events div.external-event').each(function() {

		// create an Event Object (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
		// it doesn't need to have a start or end
		var eventObject = {
			title: $.trim($(this).text()) // use the element's text as the event title
		};

		// store the Event Object in the DOM element so we can get to it later
		$(this).data('eventObject', eventObject);

		// make the event draggable using jQuery UI
		$(this).draggable({
			zIndex: 999,
			revert: true,      // will cause the event to go back to its
			revertDuration: 0  //  original position after the drag
		});
		
	});




	/* initialize the calendar
	-----------------------------------------------------------------*/

	var date = new Date();
	var d = date.getDate();
	var m = date.getMonth();
	var y = date.getFullYear();

	
	var calendar = $('#calendar').fullCalendar({
		//isRTL: true,
		 buttonText: {
			prev: '<i class="ace-icon fa fa-chevron-left"></i>',
			next: '<i class="ace-icon fa fa-chevron-right"></i>'
		},
	
		header: {
			left: 'prev,next today',
			center: 'title',
			right: 'month,agendaWeek,agendaDay'
		},
		events: [
<cfoutput><cfif structKeyExists(rc,"listTickets")><cfloop query=#rc.listTickets#>
			<cfscript>
				var h= rc.listTickets.estimate eq 1 ? "#getLabel("hour", #SESSION.languageId#)#" : "#getLabel("hours", #SESSION.languageId#)#";
				if(rc.listTickets.reportDate eq rc.listTickets.dueDate){
					var start=9;
					var end=9;
					var tyear=year(rc.listTickets.dueDate);
					var tmonth=month(rc.listTickets.dueDate);
					var tday=day(rc.listTickets.dueDate);
					var thisDate=dateFormat(rc.listTickets.dueDate,"yyyy-mm-dd"); 
					if(structKeyExists(listDate,rc.listTickets.user&"-"&thisDate)){
						if(start+listDate[rc.listTickets.user&"-"&thisDate] < 18){
							start+=listDate[rc.listTickets.user&"-"&thisDate];
							listDate[rc.listTickets.user&"-"&thisDate]+=rc.listTickets.estimate;
						}
						end=start+rc.listTickets.estimate;						
					}else{
						listDate[rc.listTickets.user&"-"&thisDate]=rc.listTickets.estimate;
						// structAppend(listDate,{rc.listTickets.user&"-"&thisDate:rc.listTickets.estimate});
						end=start+rc.listTickets.estimate;
					}
				}
			</cfscript>
			<cfif rc.listTickets.reportDate eq rc.listTickets.dueDate>
				{
					title: '#rc.listTickets.firstname# work on #rc.listTickets.code# estimate:#rc.listTickets.estimate# #h#',
					start: new Date(#tyear#, #tmonth-1#, #tday#,#start#,0),
					end: new Date(#tyear#, #tmonth-1#, #tday#,#end#,0),
					className: 'label-#rc.listTickets.color#',
					allDay: false
				},
			<cfelse>
				{
					title: '#rc.listTickets.firstname# work on #rc.listTickets.code# estimate:#rc.listTickets.estimate# #h#',
					start: new Date(#year(rc.listTickets.reportDate)#, #month(rc.listTickets.reportDate)-1#, #day(rc.listTickets.reportDate)#),
					end: new Date(#year(rc.listTickets.dueDate)#, #month(rc.listTickets.dueDate)-1#, #day(rc.listTickets.dueDate)#),
					className: 'label-#rc.listTickets.color#'
				},
			</cfif></cfloop></cfif></cfoutput>
		 
		]
		,
		editable: false,
		droppable: false, // this allows things to be dropped onto the calendar !!!
		selectable: false,
		selectHelper: false
		
		
	});
})
	function selectChange(){
		var url="";
		url+= $("#pj").val() == "" ? "" : "?pj="+$("#pj").val();
		url+= $("#as").val() == "" ? "" : ( url == ""? "?as="+$("#as").val() : "&as="+$("#as").val());
		//window.history.pushState('Filter', 'Filter', '/index.cfm/report/timeline/'+url );
		window.location="/index.cfm/report/timeline"+url;
	}
</script>