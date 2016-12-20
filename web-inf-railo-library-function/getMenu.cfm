<cfscript>
 public struct function getMenu(required any languageId) {
 	for(item in application.menus) {
 	   if(item.languageId == languageId) {
 	   		return item;
 	   }
 	}
 	return {};
 }
</cfscript>