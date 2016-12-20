<cfoutput>
    <cfset request.layout = false>
<div class="col-md-6 col-sm-8 col-xs-12">
    <cfset maxMinutes = rc.listTimeTicketUser.minutes[1] gt 600 ? rc.listTimeTicketUser.minutes[1]:600 >
    <cfloop query="#rc.listTimeTicketUser#">
        <cfset logtime = rc.listTimeTicketUser.minutes eq ''?0:rc.listTimeTicketUser.minutes>
        <!--- <h3>Time use</h3> --->
        <b> 
            <span id="TotalTimeWorked">
                #int(logtime/60)#h#(logtime mod 60)#'
            </span>
        </b>
        
        #rc.listTimeTicketUser.username# 
        <div id="divbar" class="progress progress-mini" title="Logs: #int(logtime/60)#h #(logtime mod 60)#'">
            <div style="width: #logtime/maxMinutes*100#%;" class="progress-bar progress-bar-green"></div>
        </div>
    </cfloop>
</div>
<div class="col-md-6 col-sm-8 col-xs-12">
    <cfset maxMinutes = rc.totalTimeProject.minutes[1] gt 600 ? rc.totalTimeProject.minutes[1]:600 >
    <cfloop query="#rc.totalTimeProject#">
        <cfset logtime = rc.totalTimeProject.minutes eq ''?0:rc.totalTimeProject.minutes>
        <b> 
            <span id="TotalTimeWorked">
                #int(logtime/60)#h#(logtime mod 60)#'
            </span>
        </b>
        
        <span class="pull-right"><strong>#rc.totalTimeProject.projectName#</strong></span>
        <div id="divbar" class="progress progress-mini">
            <div style="width: #logtime/maxMinutes*100#%;" class="progress-bar progress-bar-purple"></div>
        </div>
    </cfloop>
</div>
</cfoutput>