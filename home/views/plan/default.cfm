<style type="text/css">
.progress{
  margin-bottom: 5px;
  height:5px;
}
.item-row{
  border-bottom:1px #666 solid;
}
.slot{
  height: 30px;
  cursor: pointer;
}
.slot:hover{
  background-color: #777;
}
.headerCol{
  border-left: 1px dotted #888;
  min-height: 30px;
  padding:0px;
  margin: 0px;
  float: left;
  position: relative;
}
.header-plan{
  border-left: 1px solid #fff;
}
.item-col-1{width:20%;}
.item-col-2{width:40%;}
.item-col-3{width:60%;}
.item-col-4{width:80%;}
.item-col-5{width:100%;}
.over{
  float:right;
  background-color: red;
  color: white;
}
</style>
<cfoutput>
<div class="row clearfix">
  <div class="col-md-12" style="border-bottom:2px ##428bca solid;">
    <div class="row">
      <h1 class="blue">#getLabel("Plan", #SESSION.languageId#)#:&##160;&##160;
        <small style='cursor:pointer;'>
          <span id='year' class='green'></span>&##160;
          <span id='month' class='red'></span>&##160;&##160;
          <span id='week' class='pink'></span>
          <div class="pull-right" style="margin-top:7px">
            <button class="label label-lg label-purple arrowed" onClick='prewWeek()'>#getLabel("Prev", #SESSION.languageId#)#</button>
            <button class="label label-lg label-info" onClick='showPicker()'>#getLabel("Select Week", #SESSION.languageId#)#</button>
            <button class="label label-lg label-success arrowed-right" onClick='nextWeek()'>Next</button>
            <small>
            <select id="selectProject"  onchange='selectChange()'>
              <option value=0 >#getLabel("Select Project", #SESSION.languageId#)#</option>
              <cfloop query=#rc.projects#>
                <option value=#rc.projects.projectID# >#rc.projects.projectName#</option>
              </cfloop>
            </select>
            <select id="selectUser"  onchange='selectChange()'>
              <option value=0 >#getLabel("Select User", #SESSION.languageId#)#</option>
              <cfloop query=#rc.users#>
                <option value=#rc.users.userID# >#rc.users.firstname# #rc.users.lastname#</option>
              </cfloop>
            </select>
            </small>
          </div>
        </small>
      </h1>
      
    </div>
  </div>
  <div id="week-picker"class="pull-right" style='display:none;margin-right:10px;'></div>
</div>
<div id="containShow">
<div class="row clearfix">
  <div class="col-md-2 wday wday-plan clearfix">
    <div class="header">#getLabel("Programmer", #SESSION.languageId#)#</div>
  </div>
  <div class="col-md-10">
    <div class="row ">
      <div class="weekreport">
      <cfloop from="2" to="6" index="d">
          <cfswitch expression="#d#">
            <cfcase value="2">
              <cfset dDay = "#getLabel("Monday", #SESSION.languageId#)#">
            </cfcase>
            <cfcase value="3">
              <cfset dDay = "#getLabel("Tuesday", #SESSION.languageId#)#">
            </cfcase>
            <cfcase value="4">
              <cfset dDay = "#getLabel("Wednesday", #SESSION.languageId#)#">
            </cfcase>
            <cfcase value="5">
              <cfset dDay = "#getLabel("Thursday", #SESSION.languageId#)#">
            </cfcase>
            <cfcase value="6">
              <cfset dDay = "#getLabel("Friday", #SESSION.languageId#)#">
            </cfcase>
          </cfswitch>
          <div class="headerCol header-plan item-col-1 wday wday-plan clearfix">
            <div class="header"> #dDay# <span class="red" id="dow#d#"></span></div>
          </div>
      </cfloop>
      </div>
    </div>
  </div>
</div>
<div id="containList">
</div>
</div>
<div id="waiting-plan" class="hide">
  <div class="row">
    <div class="col-md-12">     
      <div class="alert alert-info">
        <strong><i class="ace-icon fa fa-spinner fa-spin orange bigger-250"></i>  #getLabel("Loading", #SESSION.languageId#)#..</strong>

        #getLabel("Please wait for a few seconds.", #SESSION.languageId#)#
        <br>
      </div>
    </div>
  </div>
</div>
<script>
  var url="";
  <cfif structKeyExists(URL,"pId")>
    $("##selectProject").find('option[value=#URL.pId#]').attr('selected','selected');
    url+= #URL.pId# == 0 ? "": '?pId=#URL.pId#' ;
  </cfif>
  <cfif structKeyExists(URL,"user")>
    $("##selectUser").find('option[value=#URL.user#]').attr('selected','selected');
    url+= #URL.user# == 0 ? "": (url==""? '?user=#URL.user#' : '&user=#URL.user#' );
  </cfif>
</script>
<div id="week-picker"></div>
  <div class="modal fade" id="ticketInfo" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content alert-info">
            <div class="modal-header alert-info">
              <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">#getLabel("Close", #SESSION.languageId#)#</span></button>
              <h3 class="modal-title" id="myModalLabel">#getLabel("Ticket Info", #SESSION.languageId#)#</h3>
            </div>
            <div class="modal-body">          
              <div class="row">
                <div class="col-md-6">
                  <label class="col-md-12" id="label1"></label>
                  <label class="col-md-12" id="label2"></label>
                  <label class="col-md-12" id="label3"></label>
                  <div class="col-md-12">
                    <label class="col-md-4">#getLabel("Move To", #SESSION.languageId#)#</label>
                    <input class="col-md-8" id="moveToInput">
                    <input type="hidden" id="ticketID">
                  </div>
                  <div class="col-md-12">
                    <label class="col-md-4">#getLabel("Assignee", #SESSION.languageId#)#</label>
                    <select class="col-md-8" id="selectAssignee" style='height:24px;'>
                      <option value=0 >#getLabel("Change Assignee", #SESSION.languageId#)#</option>
                    </select>
                  </div>
                </div>
                <div class="col-md-6">
                  <label class="col-md-12" id="labelAssignee"></label>
                  <label class="col-md-12">#getLabel("Description", #SESSION.languageId#)#:</label>
                  <div class="col-md-12" id="modalDescription"></div>
                </div>
              </div>                          
            </div>
            <div class="modal-footer">
              <button onClick='saveChange()' type="button" class="btn btn-info"data-dismiss="modal">#getLabel("Save changes", #SESSION.languageId#)#</button>
              <button type="button" class="btn btn-default" data-dismiss="modal">#getLabel("Close", #SESSION.languageId#)#</button>
            </div>
        </div>
      </div>
  </div>
</cfoutput>
<script src="/home/views/plan/jquery.weekpicker.js" ></script>
<script src="//code.jquery.com/ui/1.11.1/jquery-ui.js"></script>
<script>
$(document).ready(function(){
  $('#selectProject').chosen({allow_single_deselect:true}); 
  $('#selectUser').chosen({allow_single_deselect:true}); 
})
  function selectChange(){
    url="";
    var p=$("#selectProject").val();
    var u=$("#selectUser").val();
    url+= p == 0 ? "": '?pId='+p ;
    url+= u == 0 ? "": (url==""? '?user='+u : '&user='+u );
    window.history.pushState('Filter', 'Filter', '/index.cfm/plan/'+url );
    getData();
  }
  $(function(){
    $('#week-picker').weekpicker();
    $('#moveToInput').datepicker({
        changeMonth: true,
        changeYear: true,
        dateFormat: "yy-mm-dd"
    }).val();
  });
  function showPicker(){
    $('#week-picker').toggle("slow");
  }
  function getMonth(number){
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
    return month[number];
  }
  function getSortMonth(number){
    var month = new Array();
    month[0] = "Jan";
    month[1] = "Feb";
    month[2] = "Mar";
    month[3] = "Apr";
    month[4] = "May";
    month[5] = "Jun";
    month[6] = "Jul";
    month[7] = "Aug";
    month[8] = "Sep";
    month[9] = "Oct";
    month[10] = "Nov";
    month[11] = "Dec";
    return month[number];
  }
  var selectdate=new Date();
  var fDate=new Date();
  var tDate=new Date();
  showWeekTitle(selectdate);
  function showWeekTitle(date){
    viewDate = new Date(date.getFullYear(), date.getMonth(), date.getDate() - date.getDay()+3);
    fDate = new Date(selectdate.getFullYear(), selectdate.getMonth(), selectdate.getDate() - selectdate.getDay()+1);
    tDate = new Date(selectdate.getFullYear(), selectdate.getMonth(), selectdate.getDate() - selectdate.getDay() + 5);
    for (var i = 2; i <= 6; i++) {
      thisDate=new Date(selectdate.getFullYear(), selectdate.getMonth(), selectdate.getDate() - selectdate.getDay()+(i-1));
      $('#dow'+i).text(" "+getSortMonth(thisDate.getMonth())+" "+thisDate.getDate());

      var t=$('#week-picker').find('.ui-datepicker-current-day a');
      t= t.closest('tr');
      t.find('td>a').addClass('ui-state-active');
    };
    $('#month').text(getMonth(viewDate.getMonth()));
    $('#week').text("Week "+ (1+Math.floor(viewDate.getDate()/7)) );
    $('#year').text(viewDate.getFullYear());
    getData();
  }
  function prewWeek(){
    selectdate= new Date(selectdate.getFullYear(), selectdate.getMonth(), selectdate.getDate() - 7);
    $('#week-picker').datepicker("setDate",selectdate); 
    showWeekTitle(selectdate);
  }
  function nextWeek(){
    selectdate= new Date(selectdate.getFullYear(), selectdate.getMonth(), selectdate.getDate() + 7);
    $('#week-picker').datepicker("setDate",selectdate);
    showWeekTitle(selectdate);
  }
  function getData(){
    toggleShow();
    var projectID=$("#selectProject").val();
    var userID=$("#selectUser").val();
    var date=selectdate.getFullYear()+"-"+selectdate.getMonth()+"-"+selectdate.getDate();
    $.ajax({
      url: '/index.cfm/plan.getData'+url,
      method:'POST',
      dataType: 'json',
      data: {
        projectID: projectID,
        userID:userID,
        fYear:fDate.getFullYear(),
        fMonth:fDate.getMonth()+1,
        fDay:fDate.getDate(),
        tYear:tDate.getFullYear(),
        tMonth:tDate.getMonth()+1,
        tDay:tDate.getDate()
      },
      success: function( data ) {
        $("#containList").text("");
        for (var i =0;i< data.length; i++) {         
          $("#containList").append('\
              <div class="row clearfix item-row" id="row'+data[i].USER.ID+'">\
                <div class="col-md-2 clearfix">\
                  <div class="">'+data[i].USER.FULLNAME+'</div>\
                </div>\
                <div class="col-md-10" id="rowTickets'+data[i].USER.ID+'">\
                </div>\
              </div>');
          for (var j =0;j< data[i].TICKETS.length; j++) {
              estimate=data[i].TICKETS[j].ESTIMATE;
              over=data[i].TICKETS[j].OVER;
              overHtml='';
              if( over>0){
                if(estimate <= 0){
                  estimate=2;
                }
                overHtml='<span class="over">Over '+over+'d </span>';
              }
            if(estimate > 0 ){
              id=data[i].TICKETS[j].ID;
              dDay=data[i].TICKETS[j].DATE.split("-")[2];
              code=data[i].TICKETS[j].CODE;
              pcode=data[i].TICKETS[j].PCODE
              title=data[i].TICKETS[j].TITLE;
              color=data[i].TICKETS[j].STATUS;
              nDate=Math.ceil(estimate/8);
              percent=(estimate*100)/(nDate*8);
              $("#rowTickets"+data[i].USER.ID).append('\
                    <div class="row weekreport" id="ticket'+id+'">\
                    </div>');
              useSpace=0;
              for (var k = 2; k <= 6; k++) {
                if(useSpace >= 5)break;
                thisDate=new Date(selectdate.getFullYear(), selectdate.getMonth(), selectdate.getDate() - selectdate.getDay()+(k-1));
                day=thisDate.getDate();
                if(day==dDay){
                  useSpace+=nDate;
                  if(useSpace>5){
                    nDate-=(useSpace-5)
                  }
                  if(estimate>=nDate*8){
                    percent=100;
                  }
                  if(over > 0){
                    percent=20;
                    nDate=1;
                  }
                  $("#ticket"+id).append('\
                        <div class="headerCol item-col-'+nDate+' nopadding clearfix slot" id="slot'+id+'"title="'+title+'" onClick="showInfo('+id+')" >\
                          <div>\
                            <label class="nopadding" style="margin-bottom:0px; width:100%;"><a href="/index.cfm/ticket?project='+pcode+'&id='+code+'">'+code+'</a>('+estimate+'h)'+overHtml+'</label>\
                            <div class="progress progress-plan" style="position: static;">\
                               <div class="progress-bar progress-bar-'+color+'" style="width: '+percent+'%;"></div>\
                            </div>\
                          </div>\
                        </div>');
                }else{
                  useSpace++;
                  $("#ticket"+id).append('\
                        <div class="headerCol item-col-1 nopadding clearfix">\
                        </div>');
                }
              }; 
            }         
          };
          if(data[i].TICKETS.length == 0){
            $("#rowTickets"+data[i].USER.ID).append('\
                  <div class="row weekreport">\
                    <div class="headerCol item-col-1 nopadding clearfix"></div>\
                    <div class="headerCol item-col-1 nopadding clearfix"></div>\
                    <div class="headerCol item-col-1 nopadding clearfix"></div>\
                    <div class="headerCol item-col-1 nopadding clearfix"></div>\
                    <div class="headerCol item-col-1 nopadding clearfix"></div>\
                  </div>');
          }
        };
        toggleShow();
      }
    });
  }
  function toggleShow(){
    $("#containShow").toggleClass("hide");
    $("#waiting-plan").toggleClass("hide");
  }
  function showInfo(ticketID){
    $.ajax({
      url: '/index.cfm/plan.getDetailTicket',
      method:'POST',
      dataType: 'json',
      data: {
        ticketID: ticketID
      },
      success: function( data ) {
        $("#myModalLabel").text(data.TITLE);
        $("#label1").html("<span class='col-md-4'>Report:</span>"+data.RD);
        $("#label2").html("<span class='col-md-4'>Start:</span>"+data.SD);
        $("#label3").html("<span class='col-md-4'>DueDate:</span>"+data.DD);
        $("#labelAssignee").html("Assignee: <b>"+data.USER+"</b>");
        $("#modalDescription").html(data.DES);
        $("#ticketID").val(ticketID);
        $("#moveToInput").val(data.SD);
        $("#ticketInfo").modal({
            show: 'true'
        });

        $("#selectAssignee").find('option').remove();
        $("#selectAssignee").append('<option value=0 selected >Change Assignee</option>');
        for (var i = data.LUS.length - 1; i >= 0; i--) {
          $("#selectAssignee").append('<option value='+data.LUS[i].ID+' >'+data.LUS[i].NAME+'</option>');
        };
      }
    });
  }
  function saveChange(){
    ticketID=$("#ticketID").val();
    newDate=$("#moveToInput").val();
    newAssignee=$("#selectAssignee").val();
    if(newDate != ""){
      $.ajax({
        url: '/index.cfm/plan.changeStartDate',
        method:'POST',
        dataType: 'json',
        data: {
          ticketID: ticketID,
          newDate:newDate,
          newAssignee:newAssignee
        },
        success: function( data ) {
          if(data){
            getData();
          }else{
            alert('error! Please try again later!');
          }
        }
      });
    }
  }
</script>
