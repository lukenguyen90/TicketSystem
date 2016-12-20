component persistent="true" table="meetingminutes"{
	property name="meetingID" fieldtype="id" generator="native" setter="false";
	property name="meetingContent" ormtype="text";	
	property name="meetingDate" ormtype="timestamp";

	property name="project" fieldtype="many-to-one" cfc="projects" fkcolumn="projectID";
	property name="user"  	fieldtype="many-to-one" cfc="users" 		fkcolumn="userID" ;
}
