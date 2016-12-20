<cfoutput>
	<style type="text/css">
		.disabled {
		    pointer-events: none;
		}
		.datepicker{z-index: 9999 !important};
	</style>
	<div class="page-header">
		<div class="row">
		<h1 class="col-xs-12 col-md-6">
			#getLabel("Calendar", #SESSION.languageId#)#
		</h1>
		</div>
	</div>
	<div class="row">
		<div class="col-xs-12">
			<div class="row">
				<div class="space">
				</div>
				<div id="calendar">
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="addNewEvent">
		 <div class="modal-dialog">
		   <div class="modal-content">
		   <form class="form-horizontal" action="/index.cfm/calendar/saveEvent" method="post">
				 <div class="modal-body">
				 		<input type="hidden" name="start" id="start" value="">
				 		<input type="hidden" name="end" id="end" value="">
				 		<input type="hidden" name="allDay" id="allDay" value="">
						<div class="form-group">
							<label class="control-label col-md-4">Name:</label>
							<div class="col-md-7">
								<input type="text" class="form-control" name="title">
							</div>
							<div class="col-md-1">
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-4">Repeat Event:</label>
							<div class="col-md-7">
								<select name="repeatType" id="repeatType">
									 <option value="0">None</option>
									 <option value="1">Every Day</option>
									 <option value="2">Every Week</option>
									 <option value="3">Every Month</option>
									 <option value="4">Every Year</option>
								</select>
							</div>
							<div class="col-md-1"></div>
						</div>
						<div class="form-group" id="endEventRepeat" style="display:none">
							<label class="control-label col-md-4">End Repeat Event:</label>
							<div class="col-md-7">
								<select name="endRepeat" id="endRepeat"> 
									 <option value="0">Never</option>
									 <option value="1">Choose Day</option>
								</select>
								<div class="input-group" id="datePicker" style="display:none">
									<input class="form-control date-picker" id="id-date-picker-1" name="dateEndRepeat" type="text" data-date-format="dd-mm-yyyy" />
									<span class="input-group-addon">
										<i class="fa fa-calendar bigger-110"></i>
									</span>
								</div>
							</div>
							<div class="col-md-1"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-4">Invitees:</label>
							<div class="col-md-7">
								<select name="teamId">
									 <option value="0">ALL</option>
									 <cfloop array="#rc.teams#" index="item">
									 	<option value="#item.getProjectID()#">#item.projectName#</option>
									 </cfloop>
								</select>
							</div>
							<div class="col-md-1"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-4">Warning:</label>
							<div class="col-md-7">
								<select name="warningType">
									 <option value="0">None</option>
									 <option value="1">Before 15 min</option>
									 <option value="2">Before 30 min</option>
									 <option value="3">Before 1 hour</option>
								</select>
							</div>
							<div class="col-md-1"></div>
						</div>
						<div class="form-group">
			                <label class="col-xs-1 control-label no-padding-right" >Color</label>
			                <div class="col-md-11 inline">
			                    <label class=" btn btn-sm btn-danger">
			                        <input name="projectColor" id="danger" value="danger" type="radio" class="ace ">
			                        <span class="lbl"></span>
			                    </label>
			                    <label class=" btn btn-sm btn-pink">
			                        <input name="projectColor" id="pink" value="pink" type="radio" class="ace ">
			                        <span class="lbl"></span>
			                    </label>
			                    <label class=" btn btn-sm btn-yellow">
			                        <input name="projectColor" id="yellow" value="yellow" type="radio" class="ace ">
			                        <span class="lbl"></span>
			                    </label>
			                    <label class=" btn btn-sm btn-warning">
			                        <input name="projectColor" id="warning" value="warning" type="radio" class="ace ">
			                        <span class="lbl"></span>
			                    </label>
			                    <label class=" btn btn-sm btn-success">
			                        <input name="projectColor" id="success" value="success" type="radio" class="ace " checked>
			                        <span class="lbl"></span>
			                    </label>
			                    <label class=" btn btn-sm btn-info">
			                        <input name="projectColor" id="info" value="info" type="radio" class="ace ">
			                        <span class="lbl"></span>
			                    </label>
			                    <label class=" btn btn-sm btn-primary">
			                        <input name="projectColor" id="primary" value="primary" type="radio" class="ace ">
			                        <span class="lbl"></span>
			                    </label>
			                    <label class=" btn btn-sm btn-purple">
			                        <input name="projectColor" id="purple" value="purple" type="radio" class="ace ">
			                        <span class="lbl"></span>
			                    </label>
			                    <label class=" btn btn-sm btn-grey">
			                        <input name="projectColor" id="grey" value="grey" type="radio" class="ace ">
			                        <span class="lbl"></span>
			                    </label>
			                </div>
				        </div>
					</div>

				 <div class="modal-footer">
					<button type="submit" class="btn btn-sm btn-success" data-action="delete"><i class="ace-icon fa fa-check"></i> Save Event</button>
					<button type="button" class="btn btn-sm" data-dismiss="modal"><i class="ace-icon fa fa-times"></i> Cancel</button>
				 </div>
			</form>
		  </div>
		</div>
	</div>

</cfoutput>
<script type="text/javascript">
	jQuery(function($) {

		$('#simple-colorpicker-1').ace_colorpicker();
		
		$('#endRepeat').change(function() {
			if($(this).val()==1)
				$('#datePicker').show();
			else
				$('#datePicker').hide();
		}); 

		$('#repeatType').change(function() {
			if($(this).val()==0)
				$('#endEventRepeat').hide();
			else
				$('#endEventRepeat').show();
		});

		$('.date-picker').datepicker({
			format: 'mm/dd/yyyy',
			autoclose: true,
			todayHighlight: true
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
			events: <cfoutput>#rc.sdata#</cfoutput>
			,
			editable: true,
			droppable: true, // this allows things to be dropped onto the calendar !!!
			drop: function(date, allDay) { // this function is called when something is dropped
			
				// retrieve the dropped element's stored Event Object
				var originalEventObject = $(this).data('eventObject');
				var $extraEventClass = $(this).attr('data-class');
				
				
				// we need to copy it, so that multiple events don't have a reference to the same object
				var copiedEventObject = $.extend({}, originalEventObject);
				
				// assign it the date that was reported
				copiedEventObject.start = date;
				copiedEventObject.allDay = allDay;
				if($extraEventClass) copiedEventObject['className'] = [$extraEventClass];
				
				// render the event on the calendar
				// the last `true` argument determines if the event "sticks" (http://arshaw.com/fullcalendar/docs/event_rendering/renderEvent/)
				$('#calendar').fullCalendar('renderEvent', copiedEventObject, true);
				
				// is the "remove after drop" checkbox checked?
				if ($('#drop-remove').is(':checked')) {
					// if so, remove the element from the "Draggable Events" list
					$(this).remove();
				}
				
			}
			,
			selectable: true,
			selectHelper: true,
			select: function(start, end, allDay ) {

				$("#addNewEvent").modal('show');
				$('#start').val(start.toJSON());
				$('#end').val(end.toJSON());
				$('#allDay').val(allDay);
			}
			,
			eventClick: function(calEvent, jsEvent, view) {

				//display a modal
				var modal = 
				'<div class="modal fade">\
				  <div class="modal-dialog">\
				   <div class="modal-content">\
					 <div class="modal-body">\
					   <button type="button" class="close" data-dismiss="modal" style="margin-top:-10px;">&times;</button>\
					   <form class="no-margin">\
						  <label>Change event name &nbsp;</label>\
						  <input class="middle" autocomplete="off" type="text" value="' + calEvent.title + '" />\
						 <button type="submit" class="btn btn-sm btn-success"><i class="ace-icon fa fa-check"></i> Save</button>\
					   </form>\
					 </div>\
					 <div class="modal-footer">\
						<button type="button" class="btn btn-sm btn-danger" data-action="delete"><i class="ace-icon fa fa-trash-o"></i> Delete Event</button>\
						<button type="button" class="btn btn-sm" data-dismiss="modal"><i class="ace-icon fa fa-times"></i> Cancel</button>\
					 </div>\
				  </div>\
				 </div>\
				</div>';
			
			
				var modal = $(modal).appendTo('body');
				modal.find('form').on('submit', function(ev){
					ev.preventDefault();

					calEvent.title = $(this).find("input[type=text]").val();
					calendar.fullCalendar('updateEvent', calEvent);
					modal.modal("hide");
				});
				modal.find('button[data-action=delete]').on('click', function() {
					calendar.fullCalendar('removeEvents' , function(ev){
						return (ev._id == calEvent._id);
					})
					modal.modal("hide");
				});
				
				modal.modal('show').on('hidden', function(){
					modal.remove();
				});


				//console.log(calEvent.id);
				//console.log(jsEvent);
				//console.log(view);

				// change the border color just for fun
				//$(this).css('border-color', 'red');

			}
			
		});
		/*END initialize the calendar
	-----------------------------------------------------------------*/
	});

	function saveEvent(title,start,end,allDay){
		$.ajax({
            type: "POST",
            url: "/index.cfm/calendar/saveEvent",
            data: {
            	title : title,
            	start : start.toJSON(),
            	end   : end.toJSON(),
            	allDay:allDay
            	// startDate:picker.startDate.format('YYYY-MM-DD'),
            	// endDate: picker.endDate.format('YYYY-MM-DD')          	
            }
		});
	}
</script>