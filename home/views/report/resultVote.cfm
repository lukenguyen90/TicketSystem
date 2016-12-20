
<cfoutput>
<cfparam name="URL.date" default="#dateFormat(now(), 'yyyy-mm-dd')#">
<div class="space"></div>
<div class="row clearfix">
    <div class="col-xs-12 col-lg-12" style="border-bottom:2px ##428bca solid;">
        <h1 class="blue" >#getLabel("Total Votes", #SESSION.languageId#)#
        	<small class="month-name">#dateFormat(URL.date,'yyyy MMMM')#</small>
	        <div class="pull-right" style="margin-top: -5px;">
				<button class="label label-lg label-purple arrowed" onClick='change("prev")'>Prev</button>
				<button id="btn-current-month" class="label label-lg label-info" onClick='change("current")'>#getLabel("Current Month", #SESSION.languageId#)#</button>
				<button id="btn-next-month" class="label label-lg label-success arrowed-right" onClick='change("next")'>#getLabel("Next", #SESSION.languageId#)#</button>
	        </div>
        </h1>
    </div>
</div>
<div class="space"></div>
<div class="space"></div>
<div class="row" id="data-content">
</div>

<script type="text/javascript">
	var currentYear= #year(now())#;
	var currentMonth = #month(now())#;
	var cYear = #rc.cYear#;
	var cMonth = #rc.cMonth#;
	
	if(currentYear==cYear && currentMonth==cMonth){
		$("##btn-current-month").prop('disabled','disabled');
		$("##btn-next-month").prop('disabled','disabled');
	}
	$(document).ready(function(){
		getData();
	})
	function change(action){
		switch(action){
			case "current":
				cMonth=currentMonth;
				cYear=currentYear;
			break;
			case "prev":
				cMonth--;
			break;
			case "next":
				cMonth++;
			break;
		}
		if(cMonth>12){
			cMonth=1;
			cYear++;
		}else{
			if(cMonth<1){
				cMonth=12;
				cYear--;
			}
		}
		if(currentYear==cYear && currentMonth==cMonth){
			$("##btn-current-month").prop('disabled',true);
			$("##btn-next-month").prop('disabled',true);
		}else{
			$("##btn-current-month").prop('disabled',false);
			$("##btn-next-month").prop('disabled',false);
		}
		$('.month-name').html(cYear+' '+getMonthString(cMonth) );
		window.history.pushState('Filter', 'Filter', "/index.cfm/report/resultVote?date="+cYear+"-"+cMonth );
        getData();
	}
	function getMonthString(m) {
	    var month = new Array();
	    month[0] = "January";
	    month[1] = "February";
	    month[2] = "March";
	    month[3] = "April";
	    month[4] = "May";
	    month[5] = "June";
	    month[6] = "July";
	    month[7] = "August";
	    month[8] = "September";
	    month[9] = "October";
	    month[10] = "November";
	    month[11] = "December";
	    return month[m-1];
	}
	function getData(){
		$.ajax({
			type: 'get',
			url: '/index.cfm/report/loadVoteMonthly?date='+cYear+"-"+cMonth,
			dataType : 'html',
			beforeSend: function() {
				if ($("##loadingbar").length === 0) {
					$("body").append("<div id='loadingbar'></div>")
					$("##loadingbar").addClass("waiting").append($("<dt/><dd/>"));
					$("##loadingbar").width((50 + Math.random() * 30) + "%");
				}
			}
		}).always(function() {
			$("##loadingbar").width("101%").delay(200).fadeOut(400, function() {
				$(this).remove();
			});
		}).done(function(data) {
			$('##data-content').html(data);
		});
	}
</script>
</cfoutput>