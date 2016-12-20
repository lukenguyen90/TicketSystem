<!--- <cfdump eval=rc abort> --->
<style type="text/css">
.edit{
    float: right;
    margin-right: -28px;
    margin-top: 0;
}
.modal-edit{
    width: 30%;
}
.finish{
    margin-left: -15px;
    color: green;
}
.waiting{
    margin-left: -15px;
    color: yellow;
}
.change-date{
    border: medium none !important; 
    font-size: smaller !important; 
    text-decoration: underline dotted !important;
}
</style>
<cfset color =1 >
<cfoutput>
<!--- <cfparam name="URL.pid" default="0">
<cfparam name="URL.uid" default="0"> --->

<cfparam name="URL.date" default="#dateFormat(now(), 'yyyy-mm-dd')#">
<div class="row clearfix">
    <div class="col-xs-12 col-lg-12" style="border-bottom:2px ##428bca solid;">
        <h1 class="blue" >#getLabel("Daily Report", #SESSION.languageId#)#
            <input class="change-date date-picker" title="Change date to view report." id="date" type="text" data-date-format="yyyy-mm-dd" value="#rc.date#" onChange='change()'>
        </h1>
    </div>
</div>
    <p> &nbsp;</p>
    <!--- Chart daily report --->
    <div class="space"></div>
    <div class="space"></div>
    <div class="space"></div>
    <div class="row">
            <cfset maxDaily = rc.dailyChart.minutes[1] gt 600?rc.dailyChart.minutes[1] :600>
        <cfloop query="#rc.dailyChart#">
            <div class="col-md-8 col-sm-10 col-xs-12">
                <cfset dailyTimeTotal = rc.dailyChart.minutes eq ''?0:rc.dailyChart.minutes>
                <cfset dailyTimeTracker = rc.dailyChart.track eq ''?0:rc.dailyChart.track>
                <b> 
                    <span >
                        <strong style="font-size: 20px;">#int((dailyTimeTotal+dailyTimeTracker)/60)#h #((dailyTimeTotal+dailyTimeTracker) mod 60)#'</strong>
                    </span>
                </b>
                <span ><strong>- #rc.dailyChart.firstname# #rc.dailyChart.lastname#</strong></span>
                <div id="divbar" class="progress progress-mini">
                    <div style="width: #dailyTimeTotal/maxDaily*100#%;" class="progress-bar "></div>
                    <div style="width: #dailyTimeTracker/maxDaily*100#%;" class="progress-bar progress-bar-success"></div>
                </div>
            </div>
        </cfloop>
    </div>
    <!--- Close div chart --->
<cfif rc.prj.recordCount NEQ 0>
    <div class="row clearfix">  
        <div class="col-md-12 col-xs-12 wcontainer">              
            <div id="report">
                <cfloop array=#rc.data# index="item">
                    <cfif arrayLen(item.entry) NEQ 0>     
                        <div class="row clearfix">
                            <h3 class="header smaller lighter green project-head" style="margin-left:20px;cursor:pointer" data-id='#item.projectID#'>
                                <i class="fa fa-caret-right" id='ico-#item.projectID#'></i> Project : 
                                <a href="#item.projectURL#" target="_blank">#item.projectName#</a>
                                <cfset totallogtime = item.hours*60+item.minute>
                                <span class="label label-lg label-success arrowed pull-right" style="margin-right:20px">
                                    #int(totallogtime/60)#h #totallogtime mod 60#'</span>
                                <span class="badge badge-warning pull-right" style="margin-right:20px"></span>
                            </h3>
                            <!--- <cfdump eval=item.entry>    --->
                            <cfloop array=#item.entry# index="ent">
                                <div class="col-md-3 project-content-#item.projectID#" style="display:none;" > 
                                <!--- alert alert-block alert-success --->
                                    <cfif color mod 4 EQ 0>
                                        <cfset class = "alert alert-danger">
                                        <cfset dclass = "danger">
                                        <cfset color=color+1>
                                    <cfelseif color mod 4 EQ 1>
                                        <cfset class = "alert alert-warning">
                                        <cfset dclass = "warning">
                                        <cfset color=color+1>
                                    <cfelseif color mod 4 EQ 2>
                                        <cfset class = "alert alert-block alert-success">
                                        <cfset dclass = "success">
                                        <cfset color=color+1>
                                    <cfelse>
                                        <cfset class = "alert alert-info">
                                        <cfset dclass = "info">
                                        <cfset color=color+1>
                                    </cfif>
                                    <div class="#class#">                            
                                        <strong>#ent.userName#</strong>
                                        <cfset entLogtime = ent.hour*60+ent.minute>
                                        <b style="float:right"> Log: #int(entLogtime/60)#h #entLogtime mod 60#'</b>     
                                        <br>
                                        <cfloop array=#ent.dlogs# index="ditem">
                                            <span id="spanfinish27" class="glyphicon glyphicon-pushpin finish"></span>
                                            <span>
                                                <a href="/index.cfm/ticket?project=#item.code#&id=#ditem.code#">#ditem.ticketname#</a>
                                                <cfset logtime = ditem.hour*60+ditem.minute>
                                                <span class="badge badge-#dclass# pull-right">#int(logtime/60)#h #logtime mod 60#'</span>
                                                <span class="badge badge-#ditem.color# pull-right">#ditem.status#</span>
                                            </span>
                                        </cfloop>
                                            
                                    </div>
                                </div>
                            </cfloop>
                        </div>
                    </cfif>
                </cfloop>
            </div>
        </div>
    </div>
<cfelse>
    There are nothing to show!
</cfif>
<br>
<!--- <div id="modal" class="modal fade" tabindex="-1">
    <div class="modal-dialog  modal-edit">
        <div class="modal-content">
            <div class="modal-header no-padding">
                <div class="table-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        <span class="white">&times;</span>
                    </button>
                    Edit log
                </div>
            </div>

            <div class="modal-body no-padding">
                <form class="form-horizontal" id="validation-form">
                    <div class="form-group">
                        <div class="col-xs-12 col-sm-12">
                            <div class="clearfix">
                                <select class="col-sm-12" name="hour">
                                        <option value=0.5>0:30</option>
                                    <cfloop from="1" to="10" index="i" step="1">
                                        <option value=#i#>#i#:00</option>
                                        <option value=#i#.5>#i#:30</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="col-xs-12 col-sm-12">
                            <div class="clearfix col-xs-12 col-sm-12">
                                <textarea class="col-sm-12" name="description" id="description"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <div class="modal-footer no-margin-top">
                <div class="col-sm-4  pull-left">
                    <label>
                        <input name="finish" id="finish" type="checkbox" class="ace" />
                        <span class="lbl">Finish</span>
                    </label>
                </div>
                <button class="btn btn-sm btn-danger pull-right" data-dismiss="modal" onclick="deletelogsubmit()">
                    <i class="ace-icon glyphicon glyphicon-ok"></i>
                    Delete
                </button>
                <button class="btn btn-sm btn-success pull-right" data-dismiss="modal" onclick="editlogsubmit()">
                    <i class="ace-icon glyphicon glyphicon-ok"></i>
                    Save
                </button>
                
            </div>
        </div>
    </div>
</div> --->
</cfoutput>
<script type="text/javascript">
    var iCount = 0 ;
    var countLeaveInt = null ;
    $( "body" )
    .mouseenter(function() {
        console.log(iCount);
        iCount = 0 ;
        countLeaveInt = setInterval(function(){ countLeave() }, 60000);
    })
    .mouseleave(function() {
        countEnter();
    });
    function countEnter(){
        console.log(iCount);
        clearInterval(countLeaveInt);
        countLeaveInt = null ;
        if(iCount >= 10)Location.reload();
    }
    function countLeave(){
        iCount ++ ;
        console.log(iCount);
    }
    jQuery(function($) {
        
        //datepicker plugin
        //link
        $('.date-picker').datepicker({
            autoclose: true,
            todayHighlight: true,
            dateFormat: 'yy-mm-dd'
        })
        //show datepicker when clicking on the icon
        .next().on(ace.click_event, function(){
            $(this).prev().focus();
        });
    
        //or change it into a date range picker
    });
    $(document).on('click','.project-head',function(){
        var pId = $(this).attr('data-id');
        var $icon = $('#ico-'+pId);
        if($icon.hasClass('fa-caret-right')){
            $icon.removeClass('fa-caret-right').addClass('fa-caret-down');
        }else{
            $icon.removeClass('fa-caret-down').addClass('fa-caret-right');
        }
        $('.project-content-'+pId).slideToggle( "slow" );
    })
    function change()
    {
        var day = $("#date").val();
        <cfoutput>
            var baseURL = "#getContextRoot()#/index.cfm/report/daily/?date=" + day;
        </cfoutput>
        window.location = baseURL;
    }

</script>