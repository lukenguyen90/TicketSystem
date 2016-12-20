<style type="text/css">
.danger{color:#D15B47;border-bottom: 1px solid #D15B47;}
.warning{color:#FFB752;border-bottom: 1px solid #FFB752;}
.success{color:#87B87F;border-bottom: 1px solid #87B87F;}
.info{color:#6FB3E0;border-bottom: 1px solid #6FB3E0;}
.primary{color:#428BCA;border-bottom: 1px solid #428BCA;}
.purple{color:#9585BF;border-bottom: 1px solid #9585BF;}
.grey{color:#A0A0A0;border-bottom: 1px solid #A0A0A0;}
.yellow{color:#FEE188;border-bottom: 1px solid #FEE188;}
.mainInput{height: 30px}
.over{
  background-color: red;
  color: white;
}
.ms-parent{
	width: 100% !important;
}

</style>

<cfoutput>
<div class="row clearfix">
	<div class="row col-md-12">
		<div class="col-md-1">
		<h3 >#getLabel("Report", #SESSION.languageId#)#</h3>
		</div>
		
		<div class="pull-right" style="margin-top:20px">
			<button class="btn btn-xs btn-info" type="submit" id="btn-submit">
				<i class="ace-icon fa fa-check bigger-110"></i>
				Submit
			</button>
		</div>

		<div class="pull-right" style="width:135px; margin-right:10px;">
			<span>#getLabel("Select Reporter", #SESSION.languageId#)#</span>
			<select multiple="multiple"   id="rp" name="rp" style="width:135px;">
				<cfloop array=#rc.listUser# index="user">
					<option value="#user.userID#" >#user.firstname# #user.lastname#</option>
				</cfloop>
			</select>
		</div>

		<div class="pull-right" style="width:100px;  margin-right:10px;">
			<span>Due date</span>
			<input class="date-picker" id="dueDate" name="dueDate" type="text" data-date-format="yyyy-mm-dd" value="" style="width:100px; height:26px; border: 1px solid ##a1a1a1; border-radius: 5px;">
		</div>

		<div class="pull-right" style="width:180px; margin-right:10px;">
			<span>#getLabel("Select Type Time", #SESSION.languageId#)#</span>
			<select id="ttype" name="tt" style="width:180px"  >
				<option value="weekly">Weekly</option>
				<option value="monthly">Monthly</option>
			</select>
		</div>	

		<div class="pull-right" style="width:180px; margin-right:10px;">
			<span>#getLabel("Select Type Report", #SESSION.languageId#)#</span>
			<select id="rtype" name="tr" style="width:180px">
				<option value="1">Check in</option>
				<option value="2">Anunal leave</option>
			</select>
		</div>	
		
	</div>
</div>
<br>
<div class="row clearfix">
	<div id="tks" >
		<div class="col-md-12" id="content">
		</div>
		<div class="col-md-12">
			<span id="noreport" class="col-md-12 alert alert-warning hide">#getLabel('There are no report to show', #SESSION.languageId#)#</span>
		</div>
		<div id="waiting" class="hide col-md-12">
	      <div class="alert alert-info">
	        <strong><i class="ace-icon fa fa-spinner fa-spin orange bigger-250"></i>  #getLabel("Loading", #SESSION.languageId#)#..</strong>

	        #getLabel("Please wait for a few seconds.", #SESSION.languageId#)#
	        <br>
	      </div>
		</div>
	</div>
</div>
</cfoutput>
<script type="text/javascript"> 
	var url="";
	$(document).ready(function(){
	    $("select[multiple]").multipleSelect();
	    $("#dueDate").datepicker({
						autoclose: true,
						todayHighlight: true,
						dateFormat: 'yy-mm-dd'
					});
	});
	function getData(surl)
	{
	    displayStatus("loading");
		$.ajax({
	        url: surl,
	        method:'GET',
            dataType: 'html',
	        success: 	function(data) {
	        	if(data.trim() != "")
	        	{
            		$("#content").html(data);
            		displayStatus("haveReport");
	        	}else{
	        		displayStatus("noreport");
	        	}
	        }
	    });
	}
	function displayStatus(action){
		switch(action){
			case "loading":
    			$("#haveticket").addClass("hide");
				$("#noreport").addClass("hide");
				$("#waiting").removeClass("hide");
				break;
			case "loadingmore":
    			$("#haveticket").removeClass("hide");
				$("#noreport").addClass("hide");
				$("#waiting").removeClass("hide");
				break;
			case "haveReport":
    			$("#haveticket").removeClass("hide");
				$("#noreport").addClass("hide");
				$("#waiting").addClass("hide");
				break;
			case "noreport":
    			$("#haveticket").addClass("hide");
				$("#noreport").removeClass("hide");
				$("#waiting").addClass("hide");
				break;
		}
	}
	$("#btn-submit").on("click",function(){

		var ttype = $("#ttype").val();
		var rtype = $("#rtype").val();
		var ddate = $("#dueDate").val();
		var rp    = $("#rp").val();
		if( rtype = 1 && ddate != "" ){
			url = "/index.cfm/checkin/" + ttype + "?dd=" + ddate + "&rp=" + rp ;
	        getData(url);
		}else{
			alert("Error !");
		}
	})
	function selectChange(){
	}
</script>
