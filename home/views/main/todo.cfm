<style type="text/css">
.log-detail{
	width: 100%
}
.dropdown-hover>a>i.pull-right{
	position: absolute;
	top: 8px;
	right: -5px;
}
a.disabled {
   pointer-events: none;
   cursor: default;
}
</style>
<link rel="stylesheet" type="text/css" href="/css/todostyles.css">

<cfoutput>
<div class="page-header">
	<div class="row">
	<h1 class="col-xs-12 col-md-6">
		#getLabel("To do List ", #SESSION.languageId#)#
	</h1>
	</div>
</div><!-- /.page-header -->
<!--- todo list --->
<div class="row todo-list" id="todolist">
	<div class="col-sm-4 col-md-3 col-xs-12">
		<div class="header smaller lighter red">
			<h4>My Projects</h4>
		</div>
		<div class="dd">
			<ol class="dd-list todo-project">
				<cfset isFirstProject = true >
				<cfset firstProject = rc.listProject.projectID >
			<cfloop query=#rc.listProject#>
				<cfif rc.listProject.tickets GT 0 and SESSION.userType EQ 3>
					<li class="dd-item item-#rc.listProject.color# project-row #isFirstProject?'active':''#" data-id="#rc.listProject.projectID#" title="Click to show tickets...">
						<div class="dd-handle"> 
								<cfset a = rc.listProject.recordcount>
								<span class="#rc.listProject.color#"> #rc.listProject.shortName# </span>
								<span> #rc.listProject.projectName# </span>
								<i class="pull-right green" id="iTicketNum_#rc.listProject.projectID#">#rc.listProject.tickets#</i>	
						</div>
					</li>
				</cfif>
				<cfif SESSION.userType NEQ 3>
					<li class="dd-item item-#rc.listProject.color# project-row #isFirstProject?'active':''#" data-id="#rc.listProject.projectID#" title="Click to show tickets...">
						<div class="dd-handle"> 
								<cfset a = rc.listProject.recordcount>
								<span class="#rc.listProject.color#"> #rc.listProject.shortName# </span>
								<span> #rc.listProject.projectName# </span>
								<i class="pull-right green" id="iTicketNum_#rc.listProject.projectID#">#rc.listProject.tickets#</i>	
						</div>
					</li>
				</cfif>
				<cfset isFirstProject = false >
			</cfloop>
			</ol>
		</div>
	</div>
	<div class="col-sm-8 col-md-7 col-xs-12 " id="ticket-container">
		<div class="header smaller lighter green">
			<h4>My Tickets</h4>
		</div>
		<div class="dd">
			<ol class="dd-list todo-ticket" id="listticket">
				<div class="alert alert-info">
					Please choose project to show...
				</div>
			</ol>
		</div>
	</div>
</div>
<!--- modal insert missing log detail --->
<div class="modal fade" id="modalMisingLogDetail" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  	<div class="modal-dialog">
	    <div class="modal-content alert-info">
	      	<div class="modal-header alert-info">
	        	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">#getLabel("Close", #SESSION.languageId#)#</span></button>
	        	<h3 class="modal-title" id="modal-title-new">#getLabel("Missing log work detail ", #SESSION.languageId#)#</h3>
	      	</div>
	      	<div class="modal-body">
	      		<input type="hidden" value="" id="mld-trackID"/>
	      		<input type="hidden" value="" id="mld-ticketID"/>
	      		<div class="alert-primary" id="mld-tracker"></div>
				<div class="alert alert-warning" id="mld-alert"></div>
				<div class="row form-group">
					<label class="col-sm-3">Log detail:</label>
					<textarea class="col-sm-8 col-md-6" id="mld-description" rows="3"></textarea>
				</div>
	      	</div>
	      	<div class="modal-footer">
	        	<button type="button" class="btn btn-default" data-dismiss="modal">#getLabel("Cancel", #SESSION.languageId#)#</button>
	        	<button id="btnMLD" onClick="stopMLD()" type="button" class="btn btn-info">#getLabel("Insert Log", #SESSION.languageId#)#</button>
	      	</div>
	    </div>
  	</div>
</div>
</cfoutput>
<link rel="stylesheet" href="/css/loadingbar.css" />
<script type="text/javascript">
var project = <cfoutput>#firstProject#</cfoutput>;
$(document).ready(function(){
	var title = $('#btnCreateTicket').val();
	$.when(callAjaxTracker()).done(function(){
		loadListTicket(project);
	});
});
$(document).on('click','.project-row',function(){
	var $el = $(this);
	// var aload = true ;
	project = $el.data('id') ;
	if(!$el.hasClass('active')){
		$('.todo-project li.project-row.active').removeClass('active');
		loadListTicket(project);
		$el.addClass('active');
	}
});
function loadListTicket(pId){
	$.ajax({
		type: 'post',
		url: '/index.cfm/main/loadTodoTicket',
		data:{
			pId : pId
		},
		dataType : 'html',
		beforeSend: function() {
			if ($("#loadingbar").length === 0) {
				$("body").append("<div id='loadingbar'></div>")
				$("#loadingbar").addClass("waiting").append($("<dt/><dd/>"));
				$("#loadingbar").width((50 + Math.random() * 30) + "%");
			}
		}
	}).always(function() {
		$("#loadingbar").width("101%").delay(200).fadeOut(400, function() {
			$(this).remove();
		});
	}).done(function(data) {
		$('#listticket').html(data);
		var numTicket = $('#listticket .ticket-row').length ;
		$('#iTicketNum_'+pId).text(numTicket);
		
		$('.ticket-donow').each(function () {
			if($(this).prev('.action-buttons').css('display') == "block") {
				$(this).css('display', 'none');
			}
		});
		// if(localStorage.getItem("donow") == 1) {
		// 	$('#listticket')
		// 	.children('li')
		// 	.last()
		// 	.children('.dd2-content')
		// 	.children('.action-buttons')
		// 	.children().click();
		// }
	});
}
function stopTracker(trackID){
	$(".btn-action").addClass("disabled");
		$.ajax({
			type: 'POST',
			url: '/index.cfm/main/stopTracker',
			// data:{'trackID':trackID,'log':cmt},
			data:{'trackID':trackID},
			dataType : 'json',
			beforeSend: function() {
				loadingIcon2(trackID,'show');
				if ($("#loadingbar").length === 0) {
					$("body").append("<div id='loadingbar'></div>")
					$("#loadingbar").addClass("waiting").append($("<dt/><dd/>"));
					$("#loadingbar").width((50 + Math.random() * 30) + "%");
				}
			}
		}).always(function() {
			$("#loadingbar").width("101%").delay(200).fadeOut(400, function() {
				loadingIcon2(trackID,'hide');
				$(this).remove();
			});
		}).done(function(data) {
			if(data.success){
				loadListTicket(project);
				<cfoutput>
				localStorage.tracker#SESSION.userID# = '';
				</cfoutput>
		        $('#tracker-header').text('');
		        $('#tracker-header-timing').text('');
			}else{
				callAjaxTracker();
				if(confirm("Error : "+data.message+"! do you want reload list tickets ?"))loadListTicket(project);
			}
		});
}

function startTrack(tId){
	var ut = new Date();
	<cfoutput>
    localStorage.updateTime#SESSION.userID# = ut;
    </cfoutput>
	$(".btn-action").addClass("disabled");
	$.ajax({
		type: 'post',
		url: '/index.cfm/main/activeTracker',
		data:{
			tId : tId
		},
		dataType : 'json',
		beforeSend: function() {
			if ($("#loadingbar").length === 0) {
				$("body").append("<div id='loadingbar'></div>")
				$("#loadingbar").addClass("waiting").append($("<dt/><dd/>"));
				$("#loadingbar").width((50 + Math.random() * 30) + "%");
			}
		}
	}).always(function() {
		$("#loadingbar").width("101%").delay(200).fadeOut(400, function() {
			$(this).remove();
		});
	}).done(function(data) {
		if(data.success){
			loadListTicket(project);
			if(typeof(Storage) !== "undefined") {
				<cfoutput>
			    localStorage.tracker#SESSION.userID# = data.trackID ;
			    localStorage.ticketTitle#SESSION.userID# = data.ticket.title;
			    localStorage.ticketCode#SESSION.userID# = data.ticket.code;
				localStorage.isPause#SESSION.userID# = 0;
			    localStorage.h#SESSION.userID# = data.hou;
			    localStorage.n#SESSION.userID# = data.min;
			    localStorage.s#SESSION.userID# = 0;
			    </cfoutput>
		        $('#tracker-header').text('');
		        $('#tracker-header-timing').text('');
			}else{
				console.log('Your browser does not support Storage');
			}
		}
	});
}
// //create ticket
// $(document).on('keyup','#ticketTitle',function(event){
// 	if( checkValidCreateTicket() ){
// 		$('#btn-create-ticket').prop('disabled',false);	
// 		if(event.keyCode == 13){
// 			createTicket();
// 		}
// 	}else{
// 		$('#btn-create-ticket').prop('disabled',true);
// 	}
// });


function checkValidCreateTicket(){
	var sTicketTitle = $('#ticketTitle').val();
	var strimTitle = $.trim(sTicketTitle).split("");
	if(strimTitle == '')
		return false ;
	else 
		return true ;
}
function createTicket(){
	var title = $('#ticketTitle').val();
	var newUserID = "";
	if($('.assignedUser').length > 0) {
		newUserID = $('.assignedUser').attr('data-new-user-id');
	}
	$.ajax({
		type: 'POST',
		url: '/index.cfm/main/create',
		data: {
			title: title,
			project: project,
			assignUserID: newUserID,
			doNow: $('#mark-doNow').attr('donow')
		},
	success: function (data) {				
				if(data)
				{					
					jQuery("#ticketTitle").focus( function()
						{ 
						  $(this).val("");
						});	
					loadListTicket(project);
				}
				else{
					alert(data.message);
				}
			}
	});
}
	// change status
	$(document).on('click','.change-status',function(){
		ticketID = $(this).attr('data-id');//
		oldStatusID = $(this).attr('data-old-status-id');//			
		newStatusID = $(this).attr('data-new-status-id');//
		oldResolutionName =$(this).attr('data-old-resolution-name');//
		newResolutionName = $(this).attr('data-new-resolution-name');
		newResolutionID = $(this).attr('data-new-resolution-id');//
		isStartTracker = $(this).attr('data-isStart');
		$(".change-status").addClass("disabled");
		$.ajax({
			type: "POST",
			url: "/index.cfm/main/changeTicketStatus",
			data:{
				ticketID: ticketID,
				oldStatusID:oldStatusID,												
				newStatusID: newStatusID,						
				newResolutionID: newResolutionID,
				newResolutionName: newResolutionName,
				oldResolutionName: oldResolutionName
			},
			beforeSend: function() {
				if ($("#loadingbar").length === 0) {
					$("body").append("<div id='loadingbar'></div>")
					$("#loadingbar").addClass("waiting").append($("<dt/><dd/>"));
					$("#loadingbar").width((50 + Math.random() * 30) + "%");
				}
			}
		}).always(function() {
			$("#loadingbar").width("101%").delay(200).fadeOut(400, function() {
				$(this).remove();
			});
		}).done(function(data) {
			if(data.success){
				if(isStartTracker == 'true'){
					startTrack(ticketID);
				}else{
					loadListTicket(project);
				}
			}
			else{
				if(confirm("An Error '"+data.message+"' when update Data! do you want reload this page ?")){
						location.reload();
				}
			}
		});
	});
	
	
	// change assignee
	$(document).on('click','.change-assignee',function(){
		$(".change-assignee").addClass("disabled");

		newAssigneeID = $(this).attr('data-new-user-id');			
		ticketID = $(this).attr('data-id');	
		$.ajax({
			type: "POST",
			url: "/index.cfm/main/changeTicketAssignee",
			data:{
				ticketID: ticketID,
				userID: newAssigneeID
			},
			beforeSend: function() {
				if ($("#loadingbar").length === 0) {
					$("body").append("<div id='loadingbar'></div>")
					$("#loadingbar").addClass("waiting").append($("<dt/><dd/>"));
					$("#loadingbar").width((50 + Math.random() * 30) + "%");
				}
			}
		}).always(function() {
			$("#loadingbar").width("101%").delay(200).fadeOut(400, function() {
				$(this).remove();
			});
		}).done(function(data) {
			if(data.success){
				loadListTicket(project);
			}else{
				if(confirm("An Error '"+data.message+"' when update Data! do you want reload this page ?")){
						location.reload();
				}
			}
		});
	});
function loadingIcon(tId,action){
	$el = $('.dd-item[data-id="'+tId+'"]');
	if(action == 'show'){
		$el.find('.action-buttons').addClass('hide');
		$el.find('.loadingIcon').removeClass('hide');
	}else{
		$el.find('.action-buttons').removeClass('hide');
		$el.find('.loadingIcon').addClass('hide');
	}
}

function loadingIcon2(trId,action){
	$el = $('.dd-subitem[data-track="'+trId+'"]').prev();
	if(action === 'show'){
		$el.find('.action-buttons').addClass('hide');
		$el.find('.loadingIcon').removeClass('hide');
	}else{
		$el.find('.action-buttons').removeClass('hide');
		$el.find('.loadingIcon').addClass('hide');
	}};

//Created by Loc Nguyen 27/11/2015

$(document).on('click', '.btn-openaddTask', function () {
	closePopover229();
	if($('#addTask-popover').css('display') == 'none') {
		$('#addTask-popover').css('top','45px').css('right','18px').css('display','block');
		$('.mark-assignee').first().parent().css('background','#F4F6F7');
	}
	else {
		$('#addTask-popover').css('top','45px').css('right','18px').css('display','none');
	}
})

var isEnter = false;
var setEnterToAssign = function(event){
    if(event.keyCode === 13 || event.charCode === 13){
        if($('#addTask-popover').css('display') === "block") {
        	var $currentuser = $('.mark-assignee').first();
        	assigningUser($currentuser);
        	closePopover();
        }
    }
};
window.addEventListener? document.addEventListener('keydown', setEnterToAssign) : document.attachEvent('keydown', setEnterToAssign);

var shiftDown = false;
var setShiftDown = function(event){
    if(event.keyCode === 16 || event.charCode === 16){
        window.shiftDown = true;
    }
};

var setShiftUp = function(event){
    if(event.keyCode === 16 || event.charCode === 16){
        window.shiftDown = false;
    }
};

window.addEventListener? document.addEventListener('keydown', setShiftDown) : document.attachEvent('keydown', setShiftDown);
// window.addEventListener? document.addEventListener('keyup', setShiftUp) : document.attachEvent('keyup', setShiftUp);
$(document).on('keydown', '#ticketTitle', function(event) {
	closePopover();
	if( checkValidCreateTicket() ){
		if(event.keyCode == 13 && $('#ticketTitle').val().indexOf("@") == -1){
			createTicket();
		}
	}
});

$(document).on('keyup', '#ticketTitle', function(event) {
	var len = $('#ticketTitle').val().length;
	var $input = $('#ticketTitle').val();
	var strName = "";

	if(window.shiftDown == true && event.keyCode == 50){
		$('#addTask-popover-229').css('top','45px').css('left', (len*6 + 30) + 'px').css('display','block');
	}

	if($('#ticketTitle').val().indexOf("@") == -1) {
		$('#addTask-popover-229').css('display','none');
	}
	else {
		var temp = $('#ticketTitle').val().match(/@[a-zA-Z0-9\s]+/);
		if(temp === null) {
			strName = "";
		}
		else {
			temp = temp[0];
			strName = temp.substring(1,temp.length);
		}

		$.ajax({
			type: "POST",
			url: "/index.cfm/main/getListUsersByName",
			data:{
				strName: strName,
				pID: project
			},
			success: function (data) {
				$('#list-user-229').children('li').remove();
				if(data.DATA.length > 0 ) {
					for(var i = 0; i <= data.DATA.length; i++ ) {
					var newLI = '<li>';
						newLI += '<a href="#" class="mark-assignee-229" data-id="" data-new-user-id="' + data.DATA[i][0] + '">';
						newLI += '<img style="width:32px; height:32px; margin-right:10px;margin-left:10px;" class="img-circle" src="http://www.ticket.rasia.systems/fileupload/avatars/' + data.DATA[i][2] + '"/>';
						newLI += data.DATA[i][1];
						newLI += '</a></li>';
					$('#list-user-229').append(newLI);
					$('#list-user-229').children('li').first().css('background','#F4F6F7');
				}
				}
				
			}
		})

		if(event.keyCode == 13 && $('#ticketTitle').val().indexOf("@") > -1) {
			var currentuser = $('#list-user-229').children('li').first().children('a');
			assigningUser(currentuser);
			var stringneedrm   = $('#ticketTitle').val().match(/@[a-zA-Z0-9\s]+/);
			$('#ticketTitle').val($('#ticketTitle').val().replace(stringneedrm,""));
			closePopover229();
		}
	}


});

function closePopover229() {
	if($('#addTask-popover-229').css('display') == 'block') {
		$('#addTask-popover-229').css('display','none');
	}
};

function closePopover() {
	if($('#addTask-popover').css('display') == 'block') {
		$('#addTask-popover').css('display','none');
	}
};

$(document).on('click', '#mark-doNow', function (e) {
	e.preventDefault();
	closePopover();
	if(typeof(Storage) === "undefined") {
	    alert("Sorry ! Your current browser's version not support Storage ! Please upgrade your browser or try other browser ! Thank you !");
	}
	else {
		if($(this).children('i').hasClass('fa-star-o')) {
			var $i = $(this).children('i');
			$i.removeClass('fa-star-o');
			$i.addClass('fa-star');
			$i.css('color','red');
			$(this).attr('donow','1');
		}
		else if($(this).children('i').hasClass('fa-star')) {
			var $i = $(this).children('i');
			$i.removeClass('fa-star');
			$i.addClass('fa-star-o');
			$i.css('color','#428bca');
			$(this).attr('donow','0');
		}
	}
});

$(document).on('click', '.input-assign-delete' , function () {
	$(this).parent().remove();
});

function assigningUser (user) {
	var $currUser = user;
	var img = $currUser.children('img').attr('src');
	var newEle  = 	'<div class="assignedUser" data-id="' + $currUser.attr('data-id') + '" data-new-user-id="' + $currUser.attr('data-new-user-id') + '">'; 
		newEle	+= '<span class="input-assign-delete"><i class="icon-delete-assign fa fa-times"></i></span>'; 
		newEle	+= '<img style="width:22px; height:22px; margin-right:10px;margin-left:10px;" class="img-circle" src="' + img + '">';
		newEle  += '</div>';
	if($('.addTask').children('.assignedUser').length > 0) {
		$('.assignedUser').remove();
	}
	$('#mark-doNow').after(newEle);
}

$(document).on('click', '.mark-assignee', function (e) {
	e.preventDefault();
	assigningUser($(this));
	closePopover();
});

$(document).on('click', '.mark-assignee-229' ,function (e) {
	assigningUser($(this));
	e.preventDefault();
	closePopover229();
});

$(document).on('click', '.addTask-icon', function (e) {
	createTicket();
})
</script>