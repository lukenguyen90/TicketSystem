component output="false" displayname=""  {

	public function init(required any fw){
		variables.fw =fw;
		return this;
	}
	function default(struct rc){
		if(structKeyExists(URL,"t")){
			var type=URL.t;
		}else{
			var type=1;
		}
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute(sql:"UPDATE email SET subject=:sub,container=:cont WHERE emailID="&type,
						params:{cont:{value=rc.contain,CFSQLType='string'},
								sub:{value=rc.subject,CFSQLType='string'}});
		}
		rc.listOption=QueryExecute("SELECT * FROM email");
		for(item in rc.listOption) {
			if(!structKeyExists(rc,"type")){
				rc.type=item;
			}else{
				if(item.emailID eq type){
		   			rc.type=item;
		   		}
			}
		}
	}
	public string function getTemplate(string type){
		var query=QueryExecute("SELECT container FROM email WHERE emailKey='"&type&"'");
		return query.container;
	}
	public string function getSubject(string type){
		var query=QueryExecute("SELECT subject FROM email WHERE emailKey='"&type&"'");
		return query.subject;
	}
	public function sendRemindInsertTimeEntry(struct rc){
		var today = DateFormat(now(),'yyyy-mm-dd');
		if( dayOfWeek(today) neq 1 AND dayOfWeek(today) neq 7 ){
			rc.listUser = QueryExecute("SELECT u.userID,firstname,lastname,email from users u 
							WHERE userID not in (SELECT t.userID FROM timeentries t WHERE t.entryDate = '#today#')
							AND u.userTypeID = 2
							AND u.active = 1
							");
			var link = "http://"&CGI.HTTP_HOST;
			for(user in rc.listUser) {
				var emailbody = "<h1>Hi "&user.firstname&" </h1><p>You forgot to enter time entry for today!</p><p>Please insert now !</p><p><a href='#link#'>#link#</a></p><br><br><p>Dear<br>Rasia Team</p>";
				mailerService = new mail();
				mailerService.setTo(user.email); 
		        mailerService.setFrom("tickets@rasia.info"); 
		        mailerService.setSubject("You forgot to enter time entry for today (#today#)"); 
		        mailerService.setType("html"); 
		        mailerService.setBody(emailbody); 
		    	mailerService.send(body=emailbody);
			}
		}
	}

	public function sendEmail(userto,emailsubject,mailbody){		
		if(userto neq "" AND emailsubject neq "" AND mailbody neq ""){
			mailerService = new mail();
			mailerService.setTo(userto); 
	        mailerService.setFrom("tickets@rasia.info"); 
	        mailerService.setSubject(emailsubject); 
	        mailerService.setType("html"); 
	        mailerService.setBody(mailbody); 
	    	mailerService.send(body=mailbody);
	    }
	}
}	