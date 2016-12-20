/**
*
* @file  /C/railo-ex/webapps/ticket/api/ticket.cfc
* @author  Do Duc Tin
* @description all function of ticket
*
*/

component accessors="true" {

	public function init(){
		return this;
	}

	function getLabelChangeStatus(numeric ticketID){
		var oCurTicket = entityLoadbyPK('tickets',LsParseNumber(ticketID));		
		var testerUserID = isNull(oCurTicket.getTesterUser() ) ? 0 : oCurTicket.getTesterUser().getUserID();
		var resolutionName = isNull(oCurTicket.getResolution() ) ? "" :oCurTicket.getResolution().getSolutionName();
		var resolutionID = isNull(oCurTicket.getResolution() ) ? "" :oCurTicket.getResolution().getSolutionID();
		if(SESSION.userType neq 1){
			switch(oCurTicket.getStatus().getStatusID() ){
			case 1 :
			case 2 :
				local.lblStatus = [
					{
						lbl : 'In progress',
						name : 'In progress',
						id : 4,
						resolutionName: 'Unresolved',
						resolutionID: 0,
						comment:'Start to work!'
					},
					{
						lbl : 'Resolved-Will not fix',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Will not fix',
						resolutionID: 2,
						comment:'Will not fix!'
					},
					{
						lbl : 'Resolved-Duplicate',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Duplicate',
						resolutionID: 3,
						comment:'This ticket is Duplicate !'
					},
					{
						lbl : 'Resolved-Cannot Reproduce',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Cannot Reproduce',
						resolutionID: 5,
						comment:'I can`t do it'
					}
				];
			break;
			case 4:
				local.lblStatus = [
					{
						lbl : 'Resolved-Fixed',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Fixed',
						resolutionID: 1,
						comment:'Wait for test!'
					},
					{
						lbl : 'Resolved-Will not fix',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Will not fix',
						resolutionID: 2,
						comment:'Will not fix!'
					},
					{
						lbl : 'Resolved-Duplicate',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Duplicate',
						resolutionID: 3,
						comment:'This ticket is Duplicate !'
					},
					{
						lbl : 'Resolved-Incomplete',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Incomplete',
						resolutionID: 4,
						comment:'will do it later!'
					},
					{
						lbl : 'Resolved-Cannot Reproduce',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Cannot Reproduce',
						resolutionID: 5,
						comment:'I can`t do it'
					}
				];
			break;
			case 5:
				local.lblStatus = [
					{
						lbl : 'Reopened',
						name : 'Reopened',
						id : 2,
						resolutionName: 'Unresolved',
						resolutionID: 0,
						comment:'I want to do it again!'
					}
				];			
				if( (testerUserID) eq SESSION.userID OR SESSION.userType eq 3 ){
					arrayAppend(local.lblStatus, {
						lbl : 'Closed',
						name : 'Closed',
						id : 6,
						resolutionName: resolutionName,
						resolutionID: resolutionID,
						comment:'Done!'
					});
				}
			break;
			case 6:
				local.lblStatus = [
					{
						lbl : 'Closed',
						name : 'Closed',
						id : 6,
						resolutionName: resolutionName,
						resolutionID: resolutionID,
						comment:'Closed'
					}
				];
			}
		}else{
			switch(oCurTicket.getStatus().getStatusID() ){
			case 1:
			case 2:
			case 4:
			case 5:
				local.lblStatus = [
					{
						lbl : 'Reopened',
						name : 'Reopened',
						id : 2,
						resolutionName: 'Unresolved',
						resolutionID: 0,
						comment:'I want to do it again!'
					}
				];			
				if( (testerUserID) eq SESSION.userID OR SESSION.userType eq 3 OR SESSION.userType eq 1 and oCurTicket.getStatus().getStatusID() eq 5){
					arrayAppend(local.lblStatus, {
						lbl : 'Closed',
						name : 'Closed',
						id : 6,
						resolutionName: resolutionName,
						resolutionID: resolutionID,
						comment:'Done!'
					});
				}
			break;
			case 6:
				local.lblStatus = [
					{
						lbl : 'Closed',
						name : 'Closed',
						id : 6,
						resolutionName: resolutionName,
						resolutionID: resolutionID,
						comment:'Closed'
					}
				];
			break;
			}	
		}
		
		return local.lblStatus;	
	}

	function getListToSendEmailByStatusProgress(struct ticket, struct project){
		var listTo=QueryExecute("SELECT DISTINCT email 
                                FROM users u 
                                LEFT JOIN usertype t ON u.userTypeID=t.userTypeID
                                LEFT JOIN notification n ON u.notificationID=n.notificationID
                                WHERE n.levelNumber>1 
                                    AND (userID="&project.getLeader().getUserID()&" 
                                        OR  userID="&ticket.getReportedUser().getUserID()&"
                                        OR (n.levelNumber=3 AND u.userID in (SELECT users_userID FROM projectUsers WHERE projects_projectID="&project.getProjectID()&") )
                                        OR  n.levelNumber=4
                                        )
                                Group By email");
		return queryToListEmail(listTo)&ticket.getCc();
	}
	function queryToListEmail(query qInput){

		var toUser="";
		for(item in qInput) {
		   toUser=toUser&item.email&";";
		}
		return toUser ;
	}
	function getListToSendEmailByStatusResolved(struct ticket, struct project){
		var listTo=QueryExecute("SELECT DISTINCT email 
                                FROM users u 
                                LEFT JOIN usertype t ON u.userTypeID=t.userTypeID
                                LEFT JOIN notification n ON u.notificationID=n.notificationID
                                WHERE n.levelNumber>1 
                                AND     (   userID="&project.getLeader().getUserID()&" 
                                        OR  userID="&ticket.getReportedUser().getUserID()&"
                                        OR (n.levelNumber=3 AND u.userID in (SELECT users_userID FROM projectUsers WHERE projects_projectID="&project.getProjectID()&") )
                                        OR  n.levelNumber=4
                                        )
                                Group By email");
		return queryToListEmail(listTo)&ticket.getCc();
	}
	function getListToSendEmailByStatusClosed(struct ticket, struct project){
		var listTo=QueryExecute("SELECT DISTINCT email 
                                FROM users u 
                                LEFT JOIN usertype t ON u.userTypeID=t.userTypeID
                                LEFT JOIN notification n ON u.notificationID=n.notificationID
                                WHERE n.levelNumber>1 
                                    AND (userID="&project.getLeader().getUserID()&" 
                                    OR  userID="&ticket.getAssignedUser().getUserID()&" 
                                    OR  userID="&ticket.getReportedUser().getUserID()&" 
                                    OR (n.levelNumber=3 AND u.userID in (SELECT users_userID FROM projectUsers WHERE projects_projectID="&project.getProjectID()&") )
                                    OR  n.levelNumber=4
                                    )
                            Group By email");
		return queryToListEmail(listTo)&ticket.getCc();
	}
	
	function getListToSendEmailByStatusReopened(struct ticket, struct project){
	var listTo=QueryExecute("SELECT DISTINCT email 
                                        FROM users u 
                                        LEFT JOIN usertype t ON u.userTypeID=t.userTypeID
                                        LEFT JOIN notification n ON u.notificationID=n.notificationID
                                        WHERE n.levelNumber>1 
                                            AND (   userID="&project.getLeader().getUserID()&" 
                                                OR  userID="&ticket.getAssignedUser().getUserID()&" 
                                                OR (n.levelNumber=3 AND u.userID in (SELECT users_userID FROM projectUsers WHERE projects_projectID="&project.getProjectID()&") )
                                                OR  n.levelNumber=4
                                                )
                                            Group By email");
	return queryToListEmail(listTo)&ticket.getCc();
	}

	function changeStatus(numeric ticketID,numeric oldStatusID, numeric newStatusID,string oldResolutionName,numeric newResolutionID){			
		var ticket=entityLoadbyPK("tickets",ticketID);
		if(ticket.getIsLogStart() EQ 1){
				return {'success':false,'message':'Ticket is Tracking!'};
		}else{
			try{
		   		var estimate = isNull(ticket.getEstimate())?(isNull(ticket.getPoint())?0:(ticket.getPoint()*2)):ticket.getEstimate();
				if(ticket.getStatus().getStatusID() neq oldStatusID ){
					return {'success':false,'message':'Status has been changed by someone else, please reload this page!'};
				}else{
					var newStatus = entityLoadbyPK("status",newStatusID);
					var oldStatus = ticket.getStatus();
					var project = ticket.getProject();
					var NewResolutionName = "";
					ticket.setStatus(newStatus);
					var internal = true ;
					if(newStatusID eq 4){
			        	ticket.setStartDate(now());
			        	var newEndDate = dateAdd('d',Ceiling(ticket.getPoint()/16),now());
			        	ticket.setDueDate(newEndDate);
			        }else if(newStatusID eq 5){
			        	ticket.setResovldDate(now());
			        	internal = false ;
			        }else if(newStatusID eq 6){
			        	ticket.setClosedDate(now());
			        	internal = false ;
			        }
					if(newStatusID lt 5){
						ticket.setResolution(javacast("null",""));
					}else if(newStatusID eq 5 ){
						var resolution = entityLoadbyPK("resolution",LSParseNumber(newResolutionID));					
						ticket.setResolution(resolution);
						NewResolutionName = resolution.getSolutionName();
					}
		   			entitySave(ticket);
					// add comment auto
					if(NewResolutionName neq ""){
						var textComment = "<span class='light-blue'> Ticket's status is changed from <span class='orange'>" & oldStatus.getStatusName() & "-" & oldResolutionName &"</span> to <span class='orange'>" & newStatus.getStatusName()& "-" & NewResolutionName & "</span></span>" ;					
					}else{
						var textComment = "<span class='light-blue'> Ticket's status is changed from <span class='orange'>" & oldStatus.getStatusName() & "-" & oldResolutionName &"</span> to <span class='orange'>" & newStatus.getStatusName() & "</span></span>" ;					
					}
					var user=entityLoadbyPK("users",SESSION.userID);
					var comment = entityNew("ticketComments",{
						    comment 	= textComment,
							commentDate = now(),
						    ticket	 	= ticket,
						   	user        = user,
						   	internal 	= internal
						});
		   			entitySave(comment);
		   			// end add cmt auto
		   			// auto send email  			
		   			var email = createObject("component", "home.controllers.email");
		   			var link = "http://"&CGI.http_host&"/index.cfm/ticket?id="&ticket.getCode();
		   			var projectLink="http://"&CGI.http_host&"/index.cfm/project/?id="&project.getProjectID();
			        var mailBody="";
			        var totalEntriesTime=QueryExecute("SELECT SUM(hours) AS hours FROM timeentries WHERE ticketID="&ticketID);
			        var emailApi = new api.email();
			        switch(oldStatus.getStatusName()&"-"&newStatus.getStatusName()){
                        case "Open-In Progress":
                        case "Reopened-In Progress":
                        	emailApi.sendEmailFromOpenToInprogress(ticket,project,getListToSendEmailByStatusProgress(ticket,project));
	                        break;
                        case "Open-Resolved":
                        case "Reopened-Resolved":
                        	ticket.setResovldDate(now());	                        
	                        emailApi.sendEmailFromAnotherToResolved(ticket,project,getListToSendEmailByStatusResolved(ticket,project));
	                        break;
                        case "In Progress-Resolved":
	                        ticket.setResovldDate(now());	                      
	                        emailApi.sendEmailFromAnotherToResolved(ticket,project,getListToSendEmailByStatusResolved(ticket,project));
	                        break;
                        case "Resolved-Closed":
	                        ticket.setClosedDate(now());
	                        emailApi.sendEmailFromResolvedToClosed(ticket,project,getListToSendEmailByStatusClosed(ticket,project));  
	                        break;
                        case "Resolved-Reopened":
	    					emailApi.sendEmailFromResolvedToReopend(ticket,project,getListToSendEmailByStatusReopened(ticket,project));
                        	break;
                        // default:
                        //     mailBody="";
                        break;
                    }
			    //     if(mailBody neq "" ){
			    //     	if(listTo.recordcount neq 0){
							// var toUser="";
							// for(item in listTo) {
							//    toUser=toUser&item.email&";";
							// }
							// toUser=toUser&ticket.getCc();
							// email.sendEmail(toUser,mailSub,mailBody);
			    //     	}
			    //     }
		   			// end send email
		   			entitySave(ticket);
					return {'success':true};
				}
			}catch(any e){
				writeDump(e);
				abort;
				return {'success':false,'message':e.message};
			}
		}	
	}
	function changeAssignee(numeric ticketID, numeric newAssigneeID){
		var ticket=entityLoadbyPK("tickets", ticketID);
		if(ticket.getIsLogStart() EQ 1){
			return {'success':false,'message':'Ticket is Tracking!'};			
		}else{
			try{			
			var newAssignee = entityLoadbyPK("users",newAssigneeID);
			var oldAssignee = ticket.getAssignedUser();
			if( newAssignee.getUserID() neq oldAssignee.getUserID() ){
				// set new assignee 
				ticket.setAssignedUser(newAssignee);
				entitySave(ticket);
				var textComment =  "<span class='light-blue'> Ticket's asssignee is changed from <span class='orange'>" & oldAssignee.getFirstName() & " " & oldAssignee.getLastName() & "</span> to <span class='orange'>" &  newAssignee.getFirstName() & " " & newAssignee.getLastName() & "</span></span>" ;			
				var commentw = entityNew("ticketcomments",{
						comment  	: textComment,
						commentDate : now(),
						internal 	: false,
						ticket 		: ticket,
						user 		: entityLoadbyPK("users",SESSION.userID)
					});	
				entitySave(commentw);			
				// send email for assignee
				var project = ticket.getProject();
				var notification = newAssignee.getNotification();
				var link = "http://"&CGI.http_host&"/index.cfm/ticket?id="&ticket.getCode();
				// send email if user accepted
				var accepted = isNull(notification)? 3 : notification.getLevelNumber() ;
				if(accepted gt 1){

					var email = createObject("component", "home.controllers.email");
					var mailBody=email.getTemplate("changeAssignee");
					var mailSub=email.getSubject("changeAssignee");
					var projectLink="http://"&CGI.http_host&"/index.cfm/project/?id="&project.getProjectID();
					mailSub=ReplaceAtt(mailSub,link," ",ticket.getcode(),ticket.gettitle(),projectLink,project.getprojectName()," "," "," ");
					mailBody=ReplaceAtt(mailBody,link,mailSub,ticket.getcode(),ticket.gettitle(),projectLink,project.getprojectName()," "," "," ");
			        email.sendEmail(newAssignee.getemail(),mailSub,mailBody);
		        }
	   			// end send email
	   			var activity = entityLoad('activities',{activityName = 'Assigned' },true);
				var cmt='<a href="'&link&'"> '&ticket.getcode()&' Assigned</a>';
				createNotification(newAssignee, activity, cmt);
			}
				
			// end create action
			return {'success':true };
		}catch(any e){
			return {'success':false,'message':e.message};				
		}
		}
	}

	function getListUser(){
		var totalEntriesTime=ORMExecuteQuery(" FROM timeEntries ",true);
		// var totalEntriesTime=ORMExecuteQuery("SELECT SUM(hours) AS hours FROM timeentries WHERE ticketID="&ticketID"",true);
		return totalEntriesTime;
	}

	public string function ReplaceAtt(string textRoot,string ticketLink,string title,string ticketCode,string ticketTitle,string projectLink,string projectName,string ticketEstimate,string totalEstimate,string changeComment){
		var inputString=textRoot;
		inputString=replace(inputString,"$ticketLink$"		,ticketLink 	,"all");
		inputString=replace(inputString,"$title$"			,title 			,"all");
		inputString=replace(inputString,"$ticketCode$"		,ticketCode 	,"all");
		inputString=replace(inputString,"$ticketTitle$"		,ticketTitle 	,"all");
		inputString=replace(inputString,"$projectLink$"		,projectLink 	,"all");
		inputString=replace(inputString,"$projectName$"		,projectName 	,"all");
		inputString=replace(inputString,"$ticketEstimate$"	,ticketEstimate ,"all");
		inputString=replace(inputString,"$totalEstimate$"	,totalEstimate 	,"all");
		inputString=replace(inputString,"$changeComment$"	,changeComment 	,"all");
		return inputString;
	}

	public void function createNotification(struct user, struct activity, string comment){
		try{
			var newNotification = entityNew('actions',{
				actionDate 	: now(),
				comments 	: comment,
				isNew 		: true,
				user 		: user,
				activity 	: activity
			});
		}catch(any e){
			writeDump(e);
			abort;
		}		
	}
	
}