<cfoutput>    
    <cfset includeCSStylesheet(['plugins/iCheck/custom'])>
    <cfset DestDir =expandpath("/fileupload/csv/")>
    <cfset FileName = "Time_Detail.txt">  
    <!--- <cfif SESSION.userType neq 3> --->
        <!--- <p class="lead red">Access denied! Please contact website admin...</p>  --->
    <cfif isDefined("uploadFile")>    <!--- && SESSION.userType eq 3 --->       
        <cftry>       
        <cffile action="upload" fileField="uploadFile" destination="#DestDir##FileName#" nameconflict="overwrite" accept="text/plain, application/vnd.ms-excel">
         
        <p class="lead red">Import success!</p> 
        <cfcatch type="any"> 
            <cfoutput> 
                <p class="lead red">Please import CSV or TXT files type!</p>    
            </cfoutput> 
        </cfcatch> 
        </cftry>      
    </cfif>       
     
    <cfif fileExists("#DestDir##FileName#") EQ 'true'>
         
            <cffile action="read" file="#DestDir##FileName#" variable="csvfile">
            <cfset FileLines = listtoarray(csvfile,"#chr(13)##chr(10)#")> 
             
            <cfloop from="1" to="1" index="i">
                <cfset userid = #listgetat(FileLines[i],1)#>
                <cfset Badgenumber = #listgetat(FileLines[i],2)#>
                <cfset Name = #listgetat(FileLines[i],3)#>
                <cfset Login = #listgetat(FileLines[i],4)#>
                <cfset b = userid neq 'USERID' && Badgenumber && 'Badgenumber' and Name && 'Name' and Login && 'Login'>
            </cfloop>
            <!--- <cfif b eq 'false'>
                <p class="lead red">Wrong structure import file!</p>
            <cfelse> --->
                <cfloop from="2" to="#arrayLen(FileLines)#" index="i">            
                    <cfquery name="insertcsv" datasource="billsystem">
                        INSERT INTO timekeeper_temp(userid, badgenumber, firstname1, login, logout, import_date)
                        VALUES
                        (
                        '#listgetat(FileLines[i],1)#',
                        '#listgetat(FileLines[i],2)#',
                        '#listgetat(FileLines[i],3)#',
                        '#dateTimeFormat(#parseDateTime("#listgetat(FileLines[i],4)#", "yyyy-mm-dd HH:nn:ss")#, "yyyy-mm-dd HH:nn:ss")#',
                        '#dateTimeFormat(#parseDateTime("#listgetat(FileLines[i],5)#", "yyyy-mm-dd HH:nn:ss")#, "yyyy-mm-dd HH:nn:ss")#',
                        '#dateTimeFormat(#parseDateTime("#now()#", "yyyy-mm-dd HH:nn:ss")#, "yyyy-mm-dd HH:nn:ss")#'
                        )
                    </cfquery>
                </cfloop>
            <!--- </cfif> --->
            <!--- <cffile action="delete" file="#DestDir##FileName#">   --->    
    </cfif>
    <cfquery name = "qCheckExisting" datasource="billsystem">
        SELECT DISTINCT *
        FROM timekeeper_temp as a 
        WHERE NOT EXISTS (SELECT * FROM timekeeper AS b WHERE a.userid = b.userid AND a.login = b.login AND a.logout = b.logout)
    </cfquery>
    <cfif qCheckExisting.recordCount NEQ 0>
        <cfloop query="qCheckExisting">
            <cfquery name="insertomain" datasource="billsystem">
                INSERT INTO timekeeper(userid, badgenumber, firstname1, login, logout, import_date)
                VALUES ( '#qCheckExisting.badgenumber#', '#qCheckExisting.badgenumber#', '#qCheckExisting.firstname1#', '#dateTimeFormat(#qCheckExisting.login#, "yyyy-mm-dd HH:nn:ss")#', '#dateTimeFormat(#qCheckExisting.logout#, "yyyy-mm-dd HH:nn:ss")#', '#dateTimeFormat(#qCheckExisting.import_date#, "yyyy-mm-dd HH:nn:ss")#')
            </cfquery>
        </cfloop>     
    </cfif>
    <cfquery name="insertUseridTicket" datasource="billsystem">
        UPDATE timekeeper as b, timekeeper_userid as a SET  b.employeeid_faktura = a.employeeid_faktura
        WHERE a.userid_timekeeper = b.userid
    </cfquery>
 
    <!--- <cfquery name="insertUseridTicket" datasource="timetracker">
        UPDATE timekeeper as b, timekeeper_userid as a SET  b.userid_ticket = a.userid_ticket
        WHERE a.userid_timekeeper = b.userid
    </cfquery --->
     
    <form enctype="multipart/form-data" method="post" class="form-group" onsubmit="return validateForm(this)">
        <input type="file" id="uploadFile" name="uploadFile" title="Please choice CSV or TXT File!"/><br>       
        <button type="submit" value="Upload File" style="float: left" class="btn btn-info" onchange="isNotEmpty(this)"/> <span class="glyphicon glyphicon-upload"></span>  Upload</button>
    </form>   
</cfoutput>
<script type="text/javascript">   
    function isNotEmpty(elem){
        var str = elem.value;
        var re = /.+/;
        if(!str.match(re)) {
            alert("Please choice files to upload!");
            setTimeout("focusElement('" + elem.form.name + "', '" + elem.name + "')", 0);
            return false;
        }else {
            return true;
        }
    }
    function validateForm(form) {
        if (isNotEmpty(form.uploadFile))
            if (isValidRadio(form.accept)) {
                return true;
            }
        return false;
        location.reload();
    }   
</script>