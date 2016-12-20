<cfset request.layout = false />
<cfoutput>
	<cfscript>
		public string function getImageWithHandler(
			required string path,
			required numeric width, 
			required numeric height, 
			string scaleType = "scaleToFit") 
		cachedwithin="#createTimeSpan(0, 1, 0, 0)#"
		{
			try{
				var sType = LCase(scaleType);
				var thumbPath = GetDirectoryFromPath(path)&'/'&sType&'-'&width&'-'&height&'/'&GetFileFromPath(path) ;
				var resultPath = "ram://"&thumbPath ;
				if(not fileExists( resultPath ) ){
					var realPath = expandPath(path);
					var fImage = imageread(realPath) ;
					switch(sType){
						case "innercrop":
							if( width/height >= fImage.width/fImage.height ){
								imageScaleToFit(fImage,width,'');
								var y = int((fImage.height - height)/2) ;
								ImageCrop(fImage, 0, y, width, height) ;
							}else{
								imageScaleToFit(fImage,'',height);
								var x = int((fImage.width - width)/2) ;
								ImageCrop(fImage, x, 0, width, height) ;
							}
						break;

						case "outercrop":
							var backgroundImage = ImageNew('', width, height, 'rgb', '##222');
							if( width/height >= fImage.width/fImage.height ){
								imageScaleToFit(fImage,'',height);
								var x = int((width - fImage.width)/2) ;
								ImagePaste( backgroundImage, fImage, x, 0) ;
							}else{
								imageScaleToFit(fImage,width,'');
								var y = int((height - fImage.height)/2) ;
								ImagePaste( backgroundImage, fImage, 0, y) ;
							}
							fImage = backgroundImage ;
						break;

						case "resize":
							imageResize(fImage,width,height);
						break;

						default:
							imageScaleToFit(fImage,width,height);
						break;
					}
					if(not directoryExists( "ram://"&GetDirectoryFromPath(thumbPath) ) ){
						DirectoryCreate( "ram://"&GetDirectoryFromPath(thumbPath) );
					}
					imageWrite(fImage,"ram://"&thumbPath,true);
				}
				return resultPath;

			}catch(any e){
				writeDump(e);
				abort;
				return path;
			}
		}
	</cfscript>
<cfcontent type="image/png" file="#getImageWithHandler( URL.path, URL.width, URL.height, URL.scaleType )#" ></cfcontent>
<!--- <cfcontent type="image/png" variable="#rc.fImage#" ></cfcontent> --->
</cfoutput>