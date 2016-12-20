<!--- <cfdump eval = rc> --->
<cfset color =1>
<cfoutput>
    <cfparam name="URL.pid" default="0">
    <cfparam name="URL.uid" default="0">
    <cfparam name="URL.start" default="#dateFormat(now(),"yyyy-mm-dd")#">
    <cfparam name="URL.end" default="#dateFormat(now(),"yyyy-mm-dd")#">

    <cfif isDefined("URL.date")>
        <cfparam name="FORM.date" default="#URL.date#">
    <cfelse>
        <cfparam name="FORM.date" default="#dateFormat(now(), 'yyyy-mm-dd')#">
    </cfif>
        
    <cfparam name="URL.id" default=0>
    <!--- <cfparam name="URL.uid" default=0> --->
    <div class="row clearfix">
        <div class="col-xs-12" style="border-bottom:1px ##428bca solid;">

        <div class="col-xs-3" >
            <h1 class="blue">#getLabel("Weekly Report", #SESSION.languageId#)#:</h1>
        </div>
            <div class="input-daterange input-group pull-right" style="margin-top:18px margin-bottom:18px;">
                <input type="text" class="input form-control" style="height:26px;"<cfif structKeyExists(URL, "start")>value="#URL.start#"</cfif> name="startDay" id="startDay" onchange="change()">
                <span class="input-group-addon" style="height:26px;width:20px;padding: 2px 5px;">
                    <i class="fa fa-exchange" ></i>
                </span>

                <input type="text" class="input form-control" style="height:26px;"<cfif structKeyExists(URL, "end")>value="#URL.end#"</cfif> name="endDay" id="endDay" onchange="change()">
            </div> 

            <cfif rc.projects.recordCount NEQ 0>
            <div class="col-xs-5" style="margin-top:18px margin-bottom:18px;">
                <div class="col-xs-6">
                        <select class="col-xs-11" id="prj" name="project" onChange="change()">
                            <option value = 0 selected="selected">#getLabel("Select all projects", #SESSION.languageId#)#</option>
                            <cfoutput>
                                <cfloop query="rc.projects">
                                    <option value="#rc.projects.projectID#" #(rc.projects.projectID == URL.pid ? "selected": "")# >
                                        #rc.projects.projectName#  </option>
                                </cfloop>               
                            </cfoutput>
                        </select>
                </div>
                <div class="col-xs-6" style="margin-top:18px margin-bottom:18px;">
                        <select class="col-xs-11"  id="user" name="project" onChange="change()">
                            <option value = 0 selected="selected">#getLabel("Select all users", #SESSION.languageId#)#</option>
                                <cfloop array="#rc.users#" item="user">
                                    <option value="#user.userID#" #(user.userID eq URL.uid?"selected":"")#>
                                        #user.firstname# #user.lastname#
                                    </option>
                                </cfloop>         
                        
                        </select>
                </div>
            </div>
            </cfif>
        </div>
    </div>
    <!--- Show bar total time in week of user --->
    <div class="space"></div>
    <div class="space"></div>
    <div class="space"></div>
    <div class="row">
        <div class="col-md-6">
           <cfset minuteMax = rc.totalWeek.minutes[1] gt 600? rc.totalWeek.minutes[1]:600 >
            <cfloop query="#rc.totalWeek#">
                <cfset weekTimeTotal = rc.totalWeek.minutes == ""?0:rc.totalWeek.minutes>
                    <b> 
                        <span >
                            <strong style="font-size: 20px;">#int(weekTimeTotal/60)#h #(weekTimeTotal mod 60)#'</strong>
                        </span>
                    </b>
                    <span ><strong>- #rc.totalWeek.firstname# #rc.totalWeek.lastname#</strong></span>
                    <div id="divbar" class="progress progress-mini" title="Total time: #int(weekTimeTotal/60)#h #(weekTimeTotal mod 60)#">
                        <div style="width: #weekTimeTotal/minuteMax*100#%;" class="progress-bar progress-bar-green"></div>
                    </div>
            </cfloop>
        </div>
        <!--- Total time for every project --->
        <div class="col-md-6">
            <cfset maxChart = rc.totalTimeProject.minutes[1] gt 600 ? rc.totalTimeProject.minutes[1]:600 >
            <cfloop query="#rc.totalTimeProject#">
                <cfset logtime =rc.totalTimeProject.minutes == ""?0 :rc.totalTimeProject.minutes>
                <b> 
                    <span id="TotalTimeWorked">
                        <strong style="font-size: 20px;">#int(logtime/60)#h #(logtime mod 60)#'</strong>
                    </span>
                </b>
                
                <span class="pull-right"><strong>#rc.totalTimeProject.projectName#</strong></span>
                <div id="divbar" class="progress progress-mini" title="Total time project: #int(logtime/60)#h #(logtime mod 60)# ">
                        <div style="width: #logtime/maxChart*100#%;" class="progress-bar progress-bar-purple"></div>
                </div>
            </cfloop>
        </div>
        <!--- Close row col-md-6 --->
    </div>
    <!--- CLose row --->

    <div class="space"></div>
    <div class="space"></div>
    <div class="space"></div>

   
    <!--- <p> &nbsp;</p><p> &nbsp;</p> --->
    <cfif rc.projects.recordCount NEQ 0>
    <div class="row clearfix">
        <div class="col-md-12 wcontainer">
            <div class="row weekreport">
                <cfloop from="2" to="7" index="d">
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
                        <cfdefaultcase>
                            <cfset dDay = "#getLabel("Saturday", #SESSION.languageId#)#">
                        </cfdefaultcase>
                    </cfswitch>
                    <div class="col-md-2 wday clearfix">
                        <div class="header"> #dDay# </div>
                        <cfloop array="#rc.weekrp#" index="item">
                            <cfif arrayLen(item.logs[d]) GT 1>
                                <cfif color mod 4 EQ 0>
                                        <cfset class = "alert alert-danger">
                                        <cfset color=color+1>
                                        <cfelseif color mod 4 EQ 1>
                                            <cfset class = "alert alert-warning">
                                            <cfset color=color+1>
                                            <cfelseif color mod 4 EQ 2>
                                                <cfset class = "alert alert-block alert-success">
                                                <cfset color=color+1>
                                                <cfelse>
                                            <cfset class = "alert alert-info">
                                            <cfset color=color+1>
                                    </cfif>
                                <div class="#class#"> 
                                    <strong>#item.name#</strong>
                                    <b style="float:right"> Logs: #int(item.logs[d][1]/60)#h #(item.logs[d][1] mod 60)#'</b>
                                    
                                    <cfloop from="2" to="#arrayLen(item.logs[d])#" index="i">
                                        <br>
                                         <span>
                                            <span style="color:rgb(0, 159, 248)">#item.logs[d][i].project#</span> - <span style="color:rgb(153, 19, 30)"><a href="/index.cfm/ticket?project=#item.logs[d][i].projectcode#&id=#item.logs[d][i].ticketcode#">#item.logs[d][i].ticket#</a></span>
                                            <cfset logtime = item.logs[d][i].hours*60 + item.logs[d][i].minute>
                                            <span class="badge badge-warning pull-right">#int(logtime/60)#h #(logtime mod 60)#</span>
                                        
                                            <span class="badge badge-#item.logs[d][i].color# pull-right">#item.logs[d][i].status#</span>
                                        </span>
                                        <br>
                                        <span id="des" style="color:rgb(63, 63, 63)">#item.logs[d][i].des#</span>
                                    </cfloop>
                                    
                                    
                                </div>
                            </cfif>
                        </cfloop>
                    </div>
                </cfloop>
            </div>
        </div>                   
    </div>
    <cfelse>
        There are nothing to show!
    </cfif>
    
</cfoutput>
<script>
   /* function change()
    {
        var day = $("#date").val();
        <cfoutput>
            var baseURL = "#getContextRoot()#/index.cfm/report/weekly/?date=" + day;
        </cfoutput>
        window.location = baseURL;
    }*/
    function change()
    {
        var pid = $("#prj").val();
        var uid = $("#user").val();
        var start = $("#startDay").val();
        var end = $("#endDay").val();

        if(start == "" || end == ""){
            <cfoutput>
            var baseURL = "#getContextRoot()#/index.cfm/report/weekly/?pid="+pid+"&uid="+uid;
            </cfoutput>
        }
        else{
            <cfoutput>
            var baseURL = "#getContextRoot()#/index.cfm/report/weekly/?pid="+pid+"&uid="+uid+"&start="+start+"&end="+end;
            </cfoutput>
        }
        
        window.location = baseURL;
    }

</script>
<script type="text/javascript">
    jQuery(function($) {
        
        $('#user').chosen({allow_single_deselect:true}); 
        $('#prj').chosen({allow_single_deselect:true}); 
        
        $("#startDay").datepicker({
            format: 'yyyy/mm/dd',
            autoclose: true

        })
        $("#endDay").datepicker({
            format: 'yyyy/mm/dd',
            autoclose: true
        })
    });
</script>
