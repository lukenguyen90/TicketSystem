<cfscript>
 public string function getLabel(required any keyword, languageId) {
 	for(item in application.labels) {
 	   if(item.keyword == keyword and item.languageId == languageId) {
 	   		return item.value;
 	   }
 	}
 	return keyword;
 }
</cfscript>