<cfcomponent displayname="Upload" output="true">
<cffunction access="remote" name="uploadFile" returntype="Array" returnformat="json" output="true">
		<cfset overwriteExisting=false>
		<cfset var retVal = StructNew()>
		<cfset var sThumb="thumbnails">
		<cfif isDefined("Form.files") and Evaluate("Form.files") neq "">
			<cftry>
				<cfset local.pathfile  = "/fileupload/" & LCase(Left(Hash(now()),2)) >
				<cfset sourceimg  = expandpath(pathfile)>
				<cfif not directoryexists(sourceimg)>
					<cfdirectory action="create" directory="#sourceimg#">
				</cfif>
				<cfif not directoryexists(sourceimg&"/#sThumb#")>
					<cfdirectory action="create" directory="#sourceimg#/#sThumb#">
				</cfif>
				<cffile result="upload" action="UPLOAD" filefield="Form.files" destination="#sourceimg#" nameconflict="#iif(overwriteExisting, DE("OVERWRITE"), DE("makeunique"))#" >
				<cfif NOT upload.fileWasSaved>
					<cfset retVal.errorCode = 1>
					<cfset retVal.errorMessage = "Failed to save the file">
				</cfif>
				<cfset source = '#upload.serverDirectory#/#upload.serverfile#' />

				<cfif IsImageFile("#upload.serverDirectory#/#upload.serverfile#")>
					<cfimage action="read" source="#source#" name="img_source">
		
					<cfif ImageGetWidth(img_source) gt 1200>
						<cfset ImageScaleToFit( img_source, 1200,1400  ) />
					</cfif>
					
					<cfimage action="write" source="#img_source#" destination="#upload.serverDirectory#/#upload.serverfile#" overwrite="true">
					<cfset createThumb("",'#upload.serverDirectory#/#sThumb#/#upload.serverfile#', img_source)>
				</cfif>

				<cfcatch type="any">
					<cfdump var="#cfcatch#">
				</cfcatch>
			</cftry>
		</cfif>
		<cfscript>
			// return
			arRet=ArrayNew(1);
			arRet[1]=StructNew();
			arRet[1]["name"]=upload.serverfile;
	    	arRet[1]["size"]=upload.FileSize;
	    	arRet[1]["url"]= pathfile &'/#upload.serverfile#';
			return arRet;
		</cfscript>
	<cfreturn retVal>
</cffunction>

<cfscript>
private string function createThumb(required string sThumb, required string sName, required any oImg) {
	imageScaleToFit( arguments.oImg, 120, 120);
	local.oBackGround =imageNew("", 120, 120, "argb", "FFFFFF");
	if(arguments.oImg.width < 120) { // portrait
		imageDrawImage(oBackGround, arguments.oImg, (oBackground.width - arguments.oImg.width) /2, 0);
	} else {  // landscape
		imageDrawImage(oBackGround, arguments.oImg, 0, (oBackground.height - arguments.oImg.height) /2);
	}
	imageWrite(name:oBackGround, destination:arguments.sName, overwrite:true);
}
</cfscript>

</cfcomponent>
