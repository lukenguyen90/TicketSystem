<cfscript>
	public string function getImage(
			required string path,
			required numeric width, 
			required numeric height, 
			string scaleType = "scaleToFit") 
		cachedwithin="#createTimeSpan(0, 1, 0, 0)#"
	{
		return "/index.cfm/getImage?path=#path#&width=#width#&height=#height#&scaleType=#scaleType#";
	}
</cfscript>