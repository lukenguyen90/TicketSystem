component persistent="true" table="users" {
	property name="userID"		fieldtype="id" generator="native" setter="false";
	property name="firstname" 	ormtype="string" length=50;
	property name="lastname"  	ormtype="string" length=50;
	property name="username" 	ormtype="string" length=50;
	property name="password" 	ormtype="string" length=32;
	property name="email" 		ormtype="string" length=50;
	property name="avatar" 		ormtype="string" length=200;
	property name="endDate" 	ormtype="date";
	property name="salt" 		ormtype="string" length=32;
	property name="active" 		ormtype="boolean";
	property name="isSubscribe" ormtype="boolean";
	property name="focusProject" ormtype="integer";
	property name="isOfficial" 	ormtype="boolean";
	property name="birthday" 	ormtype="timestamp";

	// slack info	
	property name="slack" 		ormtype="string" ;

	property name="type"  		fieldtype="many-to-one"  cfc="userType" fkcolumn="userTypeID" ;
	property name="notification"fieldtype="many-to-one"  cfc="notification" fkcolumn="notificationID" ;
	property name="language" 	fieldtype="many-to-one"  cfc="language" 		fkcolumn="languageId";
	property name="company" 	fieldtype="many-to-one"  cfc="company" 		fkcolumn="companyID";

	property name="projects" 	fieldtype="many-to-many" cfc="projects" singularname="project" linktable="projectUsers" type="array";
	property name="workTypes" 	fieldtype="many-to-many" cfc="workType" singularname="workType"linktable="userWorkTypes"type="array";
	property name="modules" 	fieldtype="many-to-many" cfc="modules" singularname="module" linktable="moduleUsers" type="array";

	property name="ticketComments" 	fieldtype="one-to-many" cfc="ticketComments"fkcolumn="userID" 			singularname="ticketComment";
	property name="actions" 		fieldtype="one-to-many" cfc="actions" 		fkcolumn="userID" 			singularname="action";
	property name="moduleLeads" 	fieldtype="one-to-many" cfc="modules" 		fkcolumn="moduleLeadID" 	singularname="moduleLead";
	property name="projectLeads"	fieldtype="one-to-many" cfc="projects" 		fkcolumn="projectLeadID" 	singularname="projectLead";
	property name="timeEntries" 	fieldtype="one-to-many" cfc="timeEntries"	fkcolumn="userID" 			singularname="timeEntry";
	property name="assignedTickets"	fieldtype="one-to-many" cfc="tickets" 		fkcolumn="assignedUserID" 	singularname="assignedTicket" ;
	property name="reportedTickets" fieldtype="one-to-many" cfc="tickets" 		fkcolumn="reportedByUserID" singularname="reportedTicket" ;
	property name="mettingMinutes" fieldtype="one-to-many" cfc="meetingminutes" 		fkcolumn="userID" singularname="metting" ;

	property name="survey" fieldtype="one-to-many"  cfc="survey" fkcolumn="userID" ;
	property name="dayoff" fieldtype="one-to-many" 	cfc="dayoff" fkcolumn="userID";
}