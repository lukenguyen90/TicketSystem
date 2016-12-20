/**
*
* @file  /C/Working/railoExpress/webapps/rasia/home/controllers/login.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {

	public function init(required any fw){
		variables.fw =fw;
		return this;
	}

	public function default(struct rc)
	{
		if(CGI.REQUEST_METHOD eq "POST"){
			var user = entityLoad("users",{username:rc.username},true);
			if(isNull(user)){
				user = entityLoad("users",{email:rc.username},true);	
			}
			if (not isnull(user)){	
				var pass=hash(rc.password&user.salt);
				if(pass eq user.password){
					if(user.active){
						SESSION.userID = user.userID;
						if(NOT isNull(user.language)){
							var lg = user.language.getLanguageId();
						}else{
							var lg = 2;
						}
						SESSION.languageId = lg;

						// focus project 
						if(not isnull(user.focusProject) and user.focusProject neq '')
							SESSION.focuspj = user.focusProject ;
						// end
						SESSION.isLoggedIn 	= true;
						SESSION.name 		= user.firstname;
						SESSION.isOfficial = isNull(user.isOfficial)?false:user.isOfficial;
						switch(user.type.getUserType()){
							case "admin":
								SESSION.userType = 3;
							break;
							case "programmer":
								SESSION.userType = 2;
							break;
							case "customer":
								SESSION.userType = 1;
							break;
						
							default:
								SESSION.userType = 0;
							break;
						}

						if( user.avatar neq '' ){
							SESSION.avatar 		= user.avatar;
						}else{
							SESSION.avatar 		= '';
						}
						if(structKeyExists(URL,"redirect")){
							var queryString=replace(CGI.QUERY_STRING, "redirect="&URL.redirect&"&", "?", "one");
							
							GetPageContext().getResponse().sendRedirect("/index.cfm"&URL.redirect&queryString);		
						}else{
							GetPageContext().getResponse().sendRedirect("/index.cfm/project/overview");		
						}
						
					}else{
						rc.mess=user.username&" is not Active!<br> Please call web admin to be support!";
					}
				}else{
					rc.mess="password is incorect !";
				}
			}
			else
			{
				rc.mess="User or Email is incorect!";
			}
		}
	} 

	function register(struct rc){
  		if(CGI.REQUEST_METHOD eq "POST"){
   			if(isNull(entityLoad("users",{username:rc.username},true))){
   				if(isNull(entityLoad("users",{email:rc.email},true))){
	   				var type=entityLoadbyPK("userType",1);
	   				var endDate=CreateDate(9999, 1, 1);
	   				var saltpass = hash(createUUID());  				
				   	rc.user = entityNew("users",{
					    firstname	= rc.firstname,
					    lastname 	= rc.lastname,    
					    username 	= rc.username,
					    password 	= hash(rc.password&saltpass),
					    email    	= rc.email,
					    endDate	 	= endDate,
					   	salt        = saltpass,
					    active 		= false,
					    isSubscribe = true,
					    type 		= type,
					});
	   				entitySave(rc.user);
	   				// create action
	   				var getListUsers=QueryExecute("SELECT userID FROM users u 
	   												LEFT JOIN usertype ut ON u.userTypeID=ut.userTypeID
	   												WHERE ut.userType='Admin'");
	   				var link="http://"&CGI.http_host&"/index.cfm/user?id="&rc.user.getUserID();
	   				var getActivities=QueryExecute("SELECT activityID FROM activities WHERE activityName='Registered'");
					var cmt='<a href="'&link&'"> '&rc.user.getUsername()&' Registered</a>';
					for(item in getListUsers) {
					   var newAction=QueryExecute(sql:"INSERT INTO actions (actionDate,comments,isNew,userID,activityID)
	        															VALUES(:date,:comments,b'1',:user,:activity)",
												params:{
													date:{value=DateFormat(now(),"yyyy-mm-dd"),CFSQLType='string'},
													comments:{value=cmt,CFSQLType='string'},
													user:{value=item.userID,CFSQLType='NUMERIC'},
													activity:{value=getActivities.activityID,CFSQLType='NUMERIC'}
	        												});
					}
					
	   				GetPageContext().getResponse().sendRedirect("/index.cfm/login:");		
	   			}else{
	   				rc.mess="Email already have a people to use!";
	   			}
   			}else{
    			rc.mess="username already have a people to use!";
   			}
 		 }
	 }
}