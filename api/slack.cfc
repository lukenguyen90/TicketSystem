/**
*
* @file  /D/railo-ex/webapps/ticket/api/slack.cfc
* @author  do duc tin
* @description link to manager Incoming webhook https://rasia.slack.com/apps/A0F7XDUAZ-incoming-webhooks
* 
*/

component output="false" displayname=""  {

	public function init(){
		return this;
	}

	public function postMessage(string channel,string title,string text,string link="/index.cfm",string username="Rasia-bot",color="##36a64f"){
		var attachments = [{
 			 "color": arguments.color,
 			 "title": arguments.title,
   			 "title_link": getCurrentDomain()&arguments.link,
   			 "text": arguments.text,
   			 "mrkdwn_in": ["text", "pretext"]
 		}];
		var attachmentString = replace( serializeJson(attachments), "\\n", "\n", 'all');
		var slackUrl = " https://hooks.slack.com/services/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";
		var httpService = new http();
		 httpService.setMethod("POST"); 
   		 httpService.setCharset("utf-8");
   		 httpService.setUrl(slackUrl);  
   		 httpService.addParam(type="formfield",name="payload",value='{
   		 	"attachments": '&attachmentString&',
   		 	"username":"#arguments.username#",
   		 	"icon_emoji":":rasia:",
   		 	"channel":"#arguments.channel#"
 		}'); 
   		var result = httpService.send().getPrefix();
   		var status_code = result.status_code?:"500";
   		if( status_code == "200" ){
   			return true;
   		}
   		return false;
	}
	public array function getSlackListOfManager(){
		var managers = entityLoad("permissionManager",{isActive=true});
		var result = [];
		for(mn in managers) {
			var user = entityLoadByPk("users",mn.userId);
			if( not isNull(user) ){
				var slackID = user.slack?:"";
				if( slackID != "" ){
					var item = {id=mn.userId,slack = slackID};
					arrayAppend( result, item );
				}
			}
		}
		return result;
	}
	public string function getCurrentDomain(){
		if( CGI.HTTPS == "on" ){
			var domain = "https://";
		}else{
			var domain = "http://";
		}
		domain &= CGI.HTTP_HOST ;
		return domain;
	}
}