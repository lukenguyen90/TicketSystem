<style type="text/css">
	.unread{
		font-weight:bold;
	}
</style>
<cfoutput>
	<section id="widget-grid" class="">

	<!-- row -->
	<div class="row">
		
		<!-- NEW WIDGET START -->
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			
			<div class="row">
				<!-- col -->
				<div class="col-xs-12 col-sm-7 col-md-7 col-lg-4">
					<h1 class="page-title txt-color-blueDark">
						
						<!-- PAGE HEADER -->
						<i class="fa-fw fa fa-puzzle-piece"></i> 
							Requirement
						<span>>  
							Annual leave
						</span>
					</h1>
				</div>
			</div>

			<div class="jarviswidget well" id="wid-id-0">
				<header>
					<span class="widget-icon"> <i class="fa fa-comments"></i> </span>
					<h2>Widget Title</h2>				
					
				</header>
				<div>
					<div class="jarviswidget-editbox">
						<input class="form-control" type="text">	
					</div>
					<div class="widget-body no-padding">
						
						<table id="example" class="display projects-table table table-striped table-bordered table-hover" cellspacing="0" width="100%">
					        <thead>
					            <tr>
					                <th></th>
					                <th>No.</th>
					                <th><i class="fa fa-fw fa-user text-muted hidden-md hidden-sm hidden-xs"></i> Name</th>
					                <th><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Date</th>
					                <th>Type</th>
					                <th>Times</th>
					                <th style="max-width:40%"><i class="fa fa-fw fa-comment text-muted hidden-md hidden-sm hidden-xs"></i>Comment</th>
					                <th>Status</th>
					                <th class="hide"></th>
					                <th class="hide"></th>
					                <th class="hide"></th>
					                <th class="hide"></th>
					                <th class="hide"></th>
					                <th class="hide"></th>
					                <th class="hide"></th>
					            </tr>
					        </thead>
					        <tbody>
					        	<cfset i = 1>
					        	<cfloop array="#rc.managertime#" index="action">
					        		<cfset unread = "">
					        		<cfset status = {label:'default',name:"Waiting"}>
					        		<cfswitch expression="#action.status#">
					        			<cfcase value="0">
					        				<cfset status.label="default">
					        				<cfset status.name="WAITING">
					        			</cfcase>
					        			<cfcase value="1">
					        				<cfset status.label="success">
					        				<cfset status.name="APPROVE">
					        			</cfcase>
					        			<cfcase value="-1">
					        				<cfset status.label="danger">
					        				<cfset status.name="REJECT">
					        			</cfcase>
					        		</cfswitch>
					        		<cfset user = entityLoadbyPK('users',action.userId)>
					        		<cfset typeoff = entityLoadbyPK('dayofftype',action.typeId)>
									<cfif action.action == "">
										<cfset unread = "unread">
									</cfif>
					        		<tr class="#unread#" id="request_#action.id#">
						        		<td class=" details-control" data="#action.userId#"></td>
						        		<td style="text-align:center">#i#</td>
						        		<td><div class='project-members'><a href='/index.cfm/manager.userDetail/?u=#user.getUserID()#'>#user.getFirstname()# #user.getLastname()# </a> </div></td>
						        		<td>
						        			<span style="display:none;">#Int(action.startTime)#</span>
						        			<cfif action.isMoreday eq 1>
						        				#LSDATEFORMAT(action.startTime,'dd/mm/yyyy')# - #LSDATEFORMAT(action.endTime,'dd/mm/yyyy')#
						        			<cfelse>
						        				<cfif action.typeId eq 2>
						        					#LSDATEFORMAT(action.startTime,'dd/mm/yyyy')# (#action.startHour# : #action.endHour#) 
						        				<cfelse>
					        						#LSDATEFORMAT(action.startTime,'dd/mm/yyyy')#<cfif action.timeOff neq "all"> (#action.timeOff#)</cfif>
						        				</cfif>
						        				
						        			</cfif>
						        		</td>
						        		<td>#typeoff.statusName#</td>
						        		<td>
						        			<cfif action.typeId eq 1>
						        				#action.numberDay# days
						        			<cfelse>
						        				#action.numberDay# hours	
						        			</cfif>
						        		</td>
						        		<td>#action.reason#</td>
						        		<td><span class='label label-#status.label#'>#status.name#</span></td>
						        		<td class="hide">#action.alOffTotal - action.alOff#</td>
						        		<td class="hide">#action.sloffTotal - action.sloff#</td>
						        		<td class="hide">#action.overtimes#</td>
						        		<td class="hide">#LSDATETIMEFORMAT(action.createTime,'dd/mm/yyyy hh:nn')#</td>
						        		<td class="hide">#action.id#</td>
						        		<td class="hide">#action.typeId#</td>
						        		<td class="hide">#action.checkUser#</td>
						        	</tr>
						        	<cfset i = i+1>
					        	</cfloop>
					        </tbody>
					    </table>

					</div>
					
				</div>
				
			</div>

		</article>
		
	</div>
	<div class="row">
		<h3 class="col-xs-12">Export Excel</h3>
		<div class="col-xs-7 col-md-3">
			<select class="select2" id="exportYear">
				<cfloop from="#dateFormat(now(),"yyyy")#" to="2014" index="y" step="-1">
					<option value="#y#">#y#</option>
				</cfloop>
			</select>
		</div>
		<div class="col-xs-5">
			<a href="javascript:void(0)" onclick="exportAnnual()" class="btn btn-primary">Export</a>
		</div>
	</div>
</section>
<!-- widget grid -->
<iframe id="down_iframe" style="display:none;"></iframe>

<script type="text/javascript">
	var table = "";
	var myApp;
	$(document).ready(function() {
		myApp = myApp || (function () {
		    var pleaseWaitDiv = $('<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false"><div class="modal-header"><h1>Processing...</h1></div><div class="modal-body"><div class="progress progress-striped active"><div class="bar" style="width: 100%;"></div></div></div></div>');
		    return {
		        showPleaseWait: function() {
		            pleaseWaitDiv.modal();
		        },
		        hidePleaseWait: function () {
		            pleaseWaitDiv.modal('hide');
		        },

		    };
		})();

		function format ( d,data ) {
				    return '<table cellpadding="5" cellspacing="0" border="0" class="table table-hover table-condensed">'+
				        '<tr>'+
				            '<td style="width:10%">Annual leave exist</td>'+
				            '<td style="width:20%">'+d[8]+' days</td>'+
				            '<td style="width:10%">Sickness exist</td>'+
				            '<td style="width:20%">'+d[9]+' days</td>'+
				        '</tr>'+
				        '<tr>'+
				            '<td>Over Time exist</td>'+
				            '<td>'+d[10]+' hours</td>'+
				            '<td>Time submit</td>'+
				            '<td> '+d[11]+'</td>'+
				        '</tr>'+
				        '<tr>'+
				            '<td>Approve:</td>'+
				            '<td> '+data.sApprove+'</td>'+
				            '<td>Reject:</td>'+
				            '<td>'+data.sReject+'</td>'+
				        '</tr>'+
				        '<tr>'+
							 '<td>Confirm by:</td>'+
							 '<td>'+d[14]+'</td>'+
				            '<td>Action:</td>'+
				            '<td>'+
					            '<button type="button" class="btn btn-xs btn-primary btn-primary" id="aproveMessage" onclick="aproveMessage(1,'+d[12]+')">'+
									'<i class="ace-icon fa fa-check bigger-110"></i>'+
									'<span class="bigger-110">Aprove</span>'+
								'</button>'+
								'<button type="button" class="btn btn-xs btn-danger btn-primary" id="aproveMessage" onclick="aproveMessage(-1,'+d[12]+')" style="margin-left: 15px;">'+
									'<i class="ace-icon fa fa-times bigger-110"></i>'+
									'<span class="bigger-110">Reject</span>'+
								'</button>'+
							'</td>'+
				        '</tr>'+
				    '</table>';
				}

		table = $('##example').DataTable( {
			        "bDestroy": true,
			        "iDisplayLength": 10,
			        "order": [[1, 'asc']],
			        "fnDrawCallback": function( oSettings ) {
				       runAllCharts()
				    }
			    } );

		  $('##example tbody').on('click', 'td.details-control', function () {
			        var tr = $(this).closest('tr');
			        var row = table.row( tr );
			 
			        if ( row.child.isShown() ) {
			            // This row is already open - close it
			            row.child.hide();
			            tr.removeClass('shown');
			        }
			        else {
			            $.ajax({
					            type: "POST",
					            url: "/index.cfm/manager/getInformation",
					            data: {
					            	id:row.data()[12],
					            	type:1	            	
					            },
					            success: function( data ) {	
					            	 row.child( format(row.data(),data)).show();
					            	tr.addClass('shown');
					            }
					     });
			        }
			    });
	})
	function aproveMessage(type,id)
	{
		$.ajax({
            type: "POST",
            url: "/index.cfm/manager/aproveRequest",
            data: {
            	id: id,
            	isaprove: type,
            	rtype : 1
            },
            beforeSend: function() {
			    myApp.showPleaseWait();
			},
            success: function( data ) {	
            	myApp.hidePleaseWait();
            	if(data.msg == true)
            	{
            		$('##request_'+id).removeClass('unread');
            		var color = "";
            		var text = ""
            		if(data.stt == 1 )
            		{
            			color= "success";
            			text="APPROVE";
            		}else if(data.stt == -1)
            		{
            			color= "danger";
            			text="REJECT";
            		}else
            		{
            			color= "default";
            			text="WAITING";
            		}

            		$('##request_'+id).children('td').eq(7).html("<span class='label label-"+color+"'>"+text+"</span>");
            		 table.row( $('##request_'+id) ).child.hide();
			         $('##request_'+id).removeClass('shown');

            		$.smallBox({
						title : "Notification",
						content : "<i class='fa fa-clock-o'></i> <i>Your changes have been saved successfully.</i>",
						color : "##659265",
						iconSmall : "fa fa-check fa-2x fadeInRight animated",
						timeout : 4000
					});
            	}else{
            		$.smallBox({
							title : "Notification",
							content : "<i class='fa fa-clock-o'></i> <i>"+data.stt+"</i>",
							color : "##C46A69",
							iconSmall : "fa fa-check fa-2x fadeInRight animated",
							timeout : 4000
						});
            	}
				
            },
            error: function(){
            	location.reload();
            }
     	});
	}
	function exportAnnual(){
		var exportLink = "/index.cfm/manager.export_annual_leave?year="+$("##exportYear").val();
		document.getElementById('down_iframe').src = exportLink;
	}
	
</script>
</cfoutput>