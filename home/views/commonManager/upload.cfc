<cfcomponent displayname="Upload" output="true">
<cffunction access="remote" name="uploadFile" returntype="Array" returnformat="json" output="true">
		<cfelseif   structKeyExists(url,"directory")>
			<cfset var patchimg = '#URL.directory#' />
		<cfelse>
			<cfset var patchimg = '/resource/' />
		</cfif>
		<cfset overwriteExisting=false>
		<cfset var retVal = StructNew()>
		<!--- <cfset var namedirectory = URL.directory /> --->

		<cfif isDefined("Form.file") and Evaluate("Form.file") neq "">
			<cftry>
				<cfset local.pathfile  = patchimg>
				<cfset sourceimg  = expandpath(pathfile)>
				<cfif not directoryexists(sourceimg)>
					<cfdirectory action="create" directory="#sourceimg#">
				</cfif>
								
				<cffile result="upload" action="UPLOAD" filefield="Form.file" destination="#sourceimg#" nameconflict="#iif(overwriteExisting, DE("OVERWRITE"), DE("makeunique"))#" >
				<cfif NOT upload.fileWasSaved>
					<cfset retVal.errorCode = 1>
					<cfset retVal.errorMessage = "Failed to save the file">
				</cfif>
				<cfcatch type="any">
					<cfdump var="#cfcatch#">
				</cfcatch>
			</cftry>
		</cfif>
		<cfscript>
			arRet=ArrayNew(1);
			arRet[1]=StructNew();
			arRet[1]["name"]=upload.serverfile;
	    	arRet[1]["size"]=upload.FileSize;
	    	arRet[1]["url"]= pathfile &'/#upload.serverfile#';
			return arRet;
		</cfscript>
	<cfreturn retVal>
</cffunction>


</cfcomponent>
