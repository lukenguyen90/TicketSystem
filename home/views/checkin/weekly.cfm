<cfoutput>
    <cfset request.layout = false >
        <cfif structKeyExists(rc, "listweekcheck")>

            <table class="table table-bordered">
            <thead>
                <tr>
                    <th>User</th>                
                    <th>Monday #dateFormat(#rc.startDate#,"yyyy-mm-dd")#</th>
                    <th>Tuesday #dateFormat(dateAdd("d",1, #rc.startDate#),"yyyy-mm-dd")#</th>
                    <th>Wednesday #dateFormat(dateAdd("d",2, #rc.startDate#),"yyyy-mm-dd")#</th>
                    <th>Thursday #dateFormat(dateAdd("d",3, #rc.startDate#),"yyyy-mm-dd")#</th>
                    <th>Friday #dateFormat(dateAdd("d",4, #rc.startDate#),"yyyy-mm-dd")#</th>
                    <th>Saturday #dateFormat(dateAdd("d",5, #rc.startDate#),"yyyy-mm-dd")#</th>
                    <th>Sunday #dateFormat(dateAdd("d",6, #rc.startDate#),"yyyy-mm-dd")#</th>
                </tr>
            </thead>
            <tbody>
                <cfloop array=#rc.listweekcheck# index="user">
                    <cfset curDate = dateAdd( "d",-1,rc.startDate)>
                    <tr>
                        <td>#user.name#</td>
                        <cfloop array=#user.wDate# index="dDate">
                            <cfset dif = dateDiff('d',curDate,dDate.dDate) -1 >
                            <cfif dif gt 0 >
                                <cfloop from=1 to=#dif# index="i">
                                    <td></td>
                                </cfloop>                            
                            </cfif>
                            <cfset lcolor = dDate.logtime lt 510 ? 'red' : (dDate.logtime gt 540 ? 'blue':'')>          
                            <cfset logtime = #DateTimeFormat("#int(dDate.logtime/60)#:#int(dDate.logtime mod 60)#", 'HH:nn')#>                        
                            <cfset time1 = "08:05">
                            <cfset time2 = "09:05">
                            <cfset time3 = "17:30">
                            <cfset time4 = "18:30">
                            <cfset loginColor = dDate.login gt time1 && dDate.logout lt time3 ? 'red' : (dDate.login gt time2 && dDate.logout lt time4 ? 'red' :(dDate.login gt time1 && dDate.logtime lt 510 && dDate.logout gt time3 ? 'red' : (dDate.login gt time2 && dDate.logtime lt 510 ? 'red' : (dDate.login gt time1 && dDate.logtime lt 510 ? 'red' :(dDate.login gt time2 && dDate.logout lt time4 ? 'red' : '')))))>
                            <cfset logoutColor = dDate.login gt time1 && dDate.logout lt time3 ? 'pink' : (dDate.login gt time2 && dDate.logout lt time4 ? 'orange' : (dDate.logtime lt 510 ? 'orange':''))>

                            <td class="text-center clickTd">
                                <i class="#loginColor#">#dDate.login# </i>&nbsp;=> <i class="#logoutColor#">#dDate.logout#</i> 
                                <cfset percentTime = dDate.logtime gt 510 ? Round(510 * 100 / 720) : Round(dDate.logtime * 100 / 720)>
                                <cfset overTime = dDate.logtime gt 510 ? Round((dDate.logtime - 510) * 100 / 720) : 0>
                                <!--- <cfset percentTime = percentTime gt 100 ? 100: percentTime> --->
                                <hr/>
                                <div class="progress">
                                    <div class="progress-bar progress-bar-success" style="width: #percentTime#%;">
                                    </div>
                                    <div class="progress-bar progress-bar-danger" style="width: #overTime#%">
                                        <span class="sr-only">#Round(dDate.logtime * 100 / 510)#%</span>
                                    </div>
                                    
                                </div>
                                
                                <span class="#lcolor# ">(#logtime#)</span>
                            </td>

                            <cfset curDate = dDate.dDate>
                        </cfloop>
                        <cfset dif2 = dateDiff("d", curDate , rc.endDate)>
                        <cfif dif2 gt 0 >
                            <cfloop from=1 to=#dif2# index="j">
                                <td></td>
                            </cfloop>                            
                        </cfif>
                    </tr>
                </cfloop>                         
            </tbody>
        </table>
        </cfif>  
</cfoutput>