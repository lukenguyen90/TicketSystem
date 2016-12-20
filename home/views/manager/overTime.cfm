<style type="text/css">
	.unread{
		font-weight:bold;
	}
</style>
<cfoutput>
	<!-- widget grid -->
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
								Over Time
							</span>
						</h1>
					</div>
				</div>

				<!-- Widget ID (each widget will need unique ID)-->
				<div class="jarviswidget well" id="wid-id-0">
					<header>
						<span class="widget-icon"> <i class="fa fa-comments"></i> </span>
						<h2>Widget Title</h2>				
						
					</header>

					<!-- widget div-->
					<div>
						
						<!-- widget edit box -->
						<div class="jarviswidget-editbox">
							<!-- This area used as dropdown edit box -->
							<input class="form-control" type="text">	
						</div>
						<!-- end widget edit box -->
						
						<!-- widget content -->
						<div class="widget-body no-padding">
							
							<table id="example" class="display projects-table table table-striped table-bordered table-hover" cellspacing="0" width="100%">
						        <thead >
						            <tr >
						                <th rowspan="2" ></th>
						                <th rowspan="2" >No.</th>
						                <th rowspan="2" class="text-center"><i class="fa fa-fw fa-user text-muted hidden-md hidden-sm hidden-xs"></i> Name</th>
						                <th rowspan="2" class="text-center"> Projects</th>
						                <th rowspan="2" class="text-center" style="max-width:30%"><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Task</th>
						                <th rowspan="2" class="text-center"><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Date</th>
						                <th colspan="2"  class="text-center"> Over time</th>
						                <th rowspan="2" class="text-center">Total Hours</th>
						                <th rowspan="2" class="text-center" style="max-width:10%"><i class="fa fa-fw fa-comment text-muted hidden-md hidden-sm hidden-xs"></i>Comment</th>
						                <th rowspan="2" class="text-center">Status</th>
						            </tr>
						            <tr>
						            	<th>From</th>
						            	<th>To</th>
						            </tr>
						        </thead>
						        <tbody>
						        	<cfset i = 1>
						        	<cfloop array="#rc.overTime#" index="action">
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
										<cfif action.action == "">
											<cfset unread = "unread">
										</cfif>

						        		<tr class="#unread#" id="request_#action.id#">
							        		<td class=" details-control"></td>
							        		<td>#i#</td>
							        		<td>#user.getFirstname()# #user.getLastname()#</td>
							        		<cfif trim(action.pName) eq "">
							        			<td>External Project</td>
							        		<cfelse>
							        			<td>#action.pName#<small class='text-muted'><br><i>Leader: #action.leader#<i></small></td>
							        		</cfif>
							        		<td>
							        			<cfset tasks  = listToArray(action.tasks, ',') >
							        			<ul>
							        				<cfloop array="#tasks#" index="task">
							        					<cfset otask = entityLoadbyPK('tickets',task)>
							        					<cfif isDefined("otask")>
							        					<li><a href="" clas="text-success">#otask.getCode()# (DeadLine: #LSDATEFORMAT(otask.dueDate,'dd/mm/yyyy')#)</a></li>
							        					</cfif> 
							        				</cfloop>
							        			</ul>
							        		</td>
							        		<td>#LSDATEFORMAT(action.requestTime,'dd/mm/yyyy')#</td>
							        		<td>#action.from#</td>
							        		<td>#action.to#</td>
							        		<td>#action.hours# Hours</td>
							        		<td>#action.comment#</td>
							        		<td><span class='label label-#status.label#'>#status.name#</span></td>
							        	</tr>
							        	<cfset i = i + 1>
						        	</cfloop>
						        </tbody>
						    </table>

						</div>
						
					</div>
					
				</div>

			</article>
			
		</div>

		<!-- end row -->

		<!-- row -->

		<div class="row">

			<!-- a blank row to get started -->
			<div class="col-sm-12">
				<!-- your contents here -->
			</div>
				
		</div>

		<!-- end row -->

	</section>

<script type="text/javascript">
    var table = "";
	$(document).ready(function() {
		function format (id,data ) {
				    // `d` is the original data object for the row
				    return '<table cellpadding="5" cellspacing="0" border="0" class="table table-hover table-condensed">'+
				   		 '<tr>'+
				            '<td>Submit time:</td>'+
				            '<td> '+data.createTime+'</td>'+
				            '<td></td>'+
				            '<td></td>'+
				        '</tr>'+
				        '<tr>'+
				            '<td>Approve:</td>'+
				            '<td> '+data.sApprove+'</td>'+
				            '<td>Reject:</td>'+
				            '<td>'+data.sReject+'</td>'+
				        '</tr>'+
				        '<tr>'+
				            '<td>Action:</td>'+
				            '<td>'+
					            '<button type="button" class="btn btn-xs btn-primary btn-primary" id="aproveMessage" onclick="aproveMessage(1,'+id+')">'+
									'<i class="ace-icon fa fa-check bigger-110"></i>'+
									'<span class="bigger-110">Aprove</span>'+
								'</button>'+
							'</td>'+
							'<td>'+
								'<button type="button" class="btn btn-xs btn-danger btn-primary" id="aproveMessage" onclick="aproveMessage(-1,'+id+')">'+
									'<i class="ace-icon fa fa-times bigger-110"></i>'+
									'<span class="bigger-110">Reject</span>'+
								'</button>'+
							'</td>'+
							 '<td></td>'+
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
			       	var idRequest = tr.attr('id').split('_')[1];
			 
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
					            	id:idRequest,
					            	type:2	            	
					            },
					            success: function( data ) {	
					            	console.log(data);
					            	 row.child( format(idRequest,data)).show();
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
            	rtype : 2
            },
            success: function( data ) {	
            	console.log(data);
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

            		$('##request_'+id).children('td').eq(9).html("<span class='label label-"+color+"'>"+text+"</span>");
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
	
</script>
</cfoutput>